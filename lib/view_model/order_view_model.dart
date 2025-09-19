import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:port_karo/repo/order_repo.dart';
import 'package:port_karo/utils/utils.dart';
import 'package:port_karo/view/order/order_successfully.dart';
import 'package:port_karo/view_model/user_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderViewModel with ChangeNotifier {
  final _orderRepo = OrderRepository();
  bool _loading = false;
  bool get loading => _loading;

  int? _locationType;
  int? get locationType => _locationType;
  setLocationType(int value) {
    _locationType = value;
    notifyListeners();
  }

  dynamic _pickupData;
  dynamic _dropData;

  dynamic get pickupData => _pickupData;
  dynamic get dropData => _dropData;

  setLocationData(dynamic data) {
    print("ddddd $data");
    if (_locationType == 0) {
      print("pickup");
      _pickupData = data;
    } else {
      print("drop");

      _dropData = data;
    }
    notifyListeners();
  }

  Future<void> orderApi(
    dynamic vehicle,
    dynamic pickupAddress,
    dynamic dropAddress,
    dynamic dropLatitude,
    dynamic dropLongitude,
    dynamic pickupLatitude,
    dynamic pickupLongitude,
    dynamic senderName,
    dynamic senderPhone,
    dynamic receiverName,
    dynamic receiverPhone,
    dynamic amount,
    dynamic distance,
    dynamic payMode,
    context,
  ) async {
    print("gjvk $payMode");
    UserViewModel userViewModel = UserViewModel();
    String? UserId = await userViewModel.getUser();
    setLoading(true);
    Map data = {
      "userid": UserId,
      "vehicle_type": vehicle,
      "pickup_address": pickupAddress.toString(),
      "drop_address": dropAddress.toString(),
      "drop_latitute": dropLatitude.toString(),
      "drop_logitute": dropLongitude.toString(),
      "pickup_latitute": pickupLatitude.toString(),
      "pickup_logitute": pickupLongitude.toString(),
      "sender_name": senderName,
      "sender_phone": senderPhone,
      "reciver_name": receiverName,
      "reciver_phone": receiverPhone,
      "amount": amount,
      "distance": distance,
      "paymode": payMode,
    };
    print(jsonEncode(data));
    try {
      final response = await _orderRepo.orderApi(data);
      setLoading(false);

      if (response["status"] == 200) {
        if (payMode == "1") {
          Utils.showSuccessMessage(context, "Order successfully placed!");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const OrderSuccessfully()));
        } else {
          await launchURL(response["paymentlink"]).then((_) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const OrderSuccessfully()));
          });
        }
      } else {
        print("something went wrong");
      }
    } catch (error) {
      setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
