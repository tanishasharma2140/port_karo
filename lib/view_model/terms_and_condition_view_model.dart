import 'package:flutter/foundation.dart';
import 'package:port_karo/model/terms_and_condition_model.dart';
import 'package:port_karo/repo/terms_and_condition_repo.dart';


class TermAndConditionViewModel with ChangeNotifier {
  final _termsAndConditionRepo = TermsAndConditionRepo();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  TermsAndConditionModel? _termsAndConditionModel;
  TermsAndConditionModel? get termsAndConditionModel => _termsAndConditionModel;

  setModelData(TermsAndConditionModel value) {
    _termsAndConditionModel = value;
    notifyListeners();
  }
  Future<void> termConditionApi() async {
    _termsAndConditionRepo.termAndConditionApi().then((value) {
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