import 'package:flutter/foundation.dart';
import 'package:port_karo/model/select_vehicles_model.dart';
import 'package:port_karo/repo/select_vehicles_repo.dart';

class SelectVehiclesViewModel with ChangeNotifier {
  final _selectVehicleRepo = SelectVehicleRepo();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  SelectVehicleModel? _selectVehicleModel;
  SelectVehicleModel? get selectVehicleModel => _selectVehicleModel;

  setModelData(SelectVehicleModel value) {
    _selectVehicleModel = value;
    notifyListeners();
  }

  Future<void> selectVehiclesApi(String vehicleId) async {
    setLoading(true);
    try {
      final response = await _selectVehicleRepo.selectVehicleApi(vehicleId);
      if (response.status == 200) {
        setModelData(response);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in profileApi: $e');
      }
    } finally {
      setLoading(false);
    }
  }
}

