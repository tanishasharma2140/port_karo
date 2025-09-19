import 'package:flutter/foundation.dart';
import 'package:port_karo/model/select_vehicles_model.dart';
import 'package:port_karo/repo/select_vehicles_repo.dart';

class SelectVehiclesViewModel with ChangeNotifier {
  final _selectVehiclesRepo = SelectVehiclesRepo();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  SelectVehiclesModel? _selectVehiclesModel;
  SelectVehiclesModel? get selectVehiclesModel => _selectVehiclesModel;

  setModelData(SelectVehiclesModel value) {
    _selectVehiclesModel = value;
    notifyListeners();
  }
  Future<void> selectVehiclesApi() async {
    setLoading(true);
    try {
      final response = await _selectVehiclesRepo.selectVehiclesApi();
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

