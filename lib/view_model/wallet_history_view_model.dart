import 'package:flutter/foundation.dart';
import 'package:port_karo/model/wallet_history_model.dart';
import 'package:port_karo/repo/wallet_history_repo.dart';
import 'package:port_karo/view_model/user_view_model.dart';
class WalletHistoryViewModel with ChangeNotifier {
  final _walletHistoryRepo = WalletHistoryRepo();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  WalletHistoryModel? _walletHistoryModel;
  WalletHistoryModel? get walletHistoryModel => _walletHistoryModel;

  setModelData(WalletHistoryModel value) {
    _walletHistoryModel = value;
    notifyListeners();
  }
  Future<void> walletHistoryApi() async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _walletHistoryRepo.walletHistoryApi(userId).then((value){
      print('value:$value');
      if (value.success == true) {
        setModelData(value);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}

