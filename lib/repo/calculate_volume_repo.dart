import 'package:flutter/foundation.dart';
import 'package:port_karo/helper/helper/network/network_api_services.dart';
import 'package:port_karo/model/calculate_volume_model.dart';
import 'package:port_karo/res/api_url.dart';

import '../helper/helper/network/base_api_services.dart';

class CalculateVolumeRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<CalculateVolumeModel> calculateVolumeApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
        ApiUrl.calculateVolumeUrl,
        data,
      );
      return CalculateVolumeModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during calculateApi : $e');
      }
      rethrow;
    }
  }
}
