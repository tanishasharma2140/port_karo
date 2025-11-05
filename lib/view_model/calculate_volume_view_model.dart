import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:port_karo/model/calculate_volume_model.dart';
import 'package:port_karo/repo/calculate_volume_repo.dart';
import 'package:port_karo/utils/utils.dart';
import 'package:port_karo/view/home/widgets/pickup/schedule_screen.dart';

class CalculateVolumeViewModel with ChangeNotifier {
  final _calculateVolumeRepo = CalculateVolumeRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  CalculateVolumeModel? _calculateVolumeModel;
  CalculateVolumeModel? get calculateVolumeModel => _calculateVolumeModel;

  void setCalculateData(CalculateVolumeModel value) {
    _calculateVolumeModel = value;
    notifyListeners();
  }

  Future<void> calculateVolumeApi(
    dynamic selectedItems,
    dynamic vehicleTypeId,
    dynamic vehicleBodyTypeId,
    dynamic vehicleBodyDetailId,
    dynamic distance,
    dynamic pickupPoint,
    dynamic dropPoint,
    context,
  ) async {
    setLoading(true);

    Map data = {
      "selected_items": selectedItems,
      "vehicle_type_id": vehicleTypeId,
      "vehicle_body_types": vehicleBodyTypeId,
      "vehicle_body_detail_id": vehicleBodyDetailId,
      "distance": distance,
      "pickup_point": pickupPoint,
      "drop_point": dropPoint,
    };

    _calculateVolumeRepo
        .calculateVolumeApi(data)
        .then((value) {
          setLoading(false);
          if (value.status == true) {
            setCalculateData(value);
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (_, __, ___) => const ScheduleScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ));

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          } else {
            if (kDebugMode) {
              print('value: ${value.message}');
            }
          }
        })
        .onError((error, stackTrace) {
          setLoading(false); // ✅ Stop loader on error
          if (kDebugMode) {
            print('error: $error');
            Utils.showErrorMessage(context, 'error: $error');
          }
        });
  }
}
