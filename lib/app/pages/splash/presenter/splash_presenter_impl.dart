import 'package:firebase_auth/firebase_auth.dart';
import 'package:planilla_android/app/pages/splash/presenter/splash_presenter.dart';
import 'package:planilla_android/app/pages/splash/view/splash_view.dart';

class SplashPresenterImpl implements SplashPresenter {
  late final SplashView _view;


  @override
  Future<void> checkLogin() async{
    _view.showLoading();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _view.isLogged(true);
      } else {
        _view.isLogged(false);
      }
    });
  }

  @override
    set view(view) => _view = view;
}