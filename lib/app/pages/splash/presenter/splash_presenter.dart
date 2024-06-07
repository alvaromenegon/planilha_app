import 'package:planilla_android/app/core/mvp/presenter.dart';

abstract class SplashPresenter extends AppPresenter{
  Future<void> checkLogin();
}