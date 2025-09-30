import 'package:flutter/foundation.dart';
import 'package:port_karo/helper/helper/network/base_api_services.dart';
import 'package:port_karo/helper/helper/network/network_api_services.dart';
import 'package:port_karo/model/select_vehicles_model.dart';
import 'package:port_karo/res/api_url.dart';

class SelectVehicleRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<SelectVehicleModel> selectVehicleApi(String vehicleId) async {
    String? url = "${ApiUrl.selectVehiclesUrl}vehicle_id=$vehicleId";
    try {
      dynamic response = await _apiServices.getGetApiResponse(url);
      return SelectVehicleModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during selectVehicleApi: $e');
      }
      rethrow;
    }
  }
}
