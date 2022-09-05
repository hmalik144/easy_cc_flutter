import 'package:stacked/stacked.dart';

import 'Utils/ViewState.dart';

abstract class BaseViewmodel extends BaseViewModel{

  ViewState _viewState = Idle();
  ViewState get viewState => _viewState;

  void onStart() {
    _viewState = HasStarted();
    notifyListeners();
  }

  void onSuccess(dynamic data) {
    _viewState = HasData(data);
    notifyListeners();
  }

  void onError(String error) {
    _viewState = HasError(error);
    notifyListeners();
  }
}