import 'package:flutter/foundation.dart';
import 'package:port_karo/model/privacy_policy_model.dart';
import 'package:port_karo/repo/privacy_policy_repo.dart';


class PrivacyPolicyViewModel with ChangeNotifier {
  final _privacyPolicyRepo = PrivacyPolicyRepo();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  PrivacyPolicyModel? _privacyPolicyModel;
  PrivacyPolicyModel? get privacyPolicyModel => _privacyPolicyModel;

  setModelData(PrivacyPolicyModel value) {
    _privacyPolicyModel = value;
    notifyListeners();
  }
  Future<void> privacyPolicyApi() async {
    _privacyPolicyRepo.privacyPolicyApi().then((value) {
      if (value.status == 200) {
        setModelData(value);
        setLoading(false);
      } else {
        setLoading(false);
      }
    }
    ).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}