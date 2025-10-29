import 'package:flutter/foundation.dart';
import 'package:port_karo/repo/driver_rating_repo.dart';
import 'package:port_karo/utils/utils.dart';


class DriverRatingViewModel with ChangeNotifier {
  final _driverRatingRepo = DriverRatingRepo();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverRatingApi (context, String driverId, String rating) async {
    setLoading(true);

    Map data = {
      "driver_id": driverId,
      "rating": rating
    };
    print("driverRating: ${data}");

    _driverRatingRepo.driverRatingApi(data).then((value) async {
      setLoading(false);
      if (value['status'] == 200) {
        Utils.showSuccessMessage(context, value['message']);
      } else {
        Utils.showErrorMessage(context, value["message"]);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
