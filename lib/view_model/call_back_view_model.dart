import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:port_karo/repo/call_back_repo.dart';
import 'package:port_karo/view/bottom_nav_bar.dart';
import 'package:port_karo/view_model/profile_view_model.dart';
import 'package:port_karo/view_model/update_ride_status_view_model.dart';
import 'package:provider/provider.dart';

class CallBackViewModel with ChangeNotifier {
  final _callBackRepo = CallBackRepo();
  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> callBackApi({
    required String orderID,
    required int status,
    required BuildContext context,
  }) async {
    print("callBackApi started");
    setLoading(true);

    try {
      Map<String, dynamic> data = {"order_id": orderID, "status": status};
      print("Sending data: $data");

      final response = await _callBackRepo.callBackApi(data);
      print("Raw API response: $response");

      setLoading(false);
      print("Loader stopped ✅");

      if (response['success'] == true) {
        print("Callback success: ${response['message']}");

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response['message'].toString())));

        // 🔥 Use the firebase_order_id returned from API
        final firebaseOrderId = response['firebase_order_id'].toString();

        // ✅ Update ride_status = 6 in Firebase
        await _updateRideStatus(firebaseOrderId, context);

        Provider.of<UpdateRideStatusViewModel>(
          context,
          listen: false,
        ).updateRideApi(context, firebaseOrderId, "6");
        Provider.of<ProfileViewModel>(context,listen: false).profileApi(context);

        // ✅ Navigate to Bottom Navbar after short delay
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigationPage()),
            (route) => false,
          );
        });
      } else {
        print("Callback failed: ${response['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response['message']}')),
        );
      }
    } catch (e) {
      print("Error caught ❌ $e");
      setLoading(false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  /// 🔥 Update ride_status to 6 in Firebase for the given order ID
  Future<void> _updateRideStatus(
    String firebaseOrderId,
    BuildContext context,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final docRef = firestore.collection('order').doc(firebaseOrderId);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({'ride_status': 6});
        print("✅ ride_status updated to 6 for order ID: $firebaseOrderId");
      } else {
        print("⚠️ Order not found in Firestore: $firebaseOrderId");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order not found in Firestore.')),
        );
      }
    } catch (e) {
      print("❌ Error updating ride_status: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating ride status: $e')));
    }
  }
}
