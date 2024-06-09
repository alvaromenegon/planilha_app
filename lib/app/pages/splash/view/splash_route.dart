import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:planilla_android/app/pages/login/login_page.dart';
import 'package:planilla_android/app/pages/splash/presenter/splash_presenter_impl.dart';

class SplashRoute extends FlutterGetItPageRouter{
  const SplashRoute({super.key});

  @override
  List<Bind<Object>> get bindings => [
    Bind.lazySingleton((i) => SplashPresenterImpl()),
  ];

  @override
  String get routeName => '/auth/login';

  @override
  WidgetBuilder get view => (_) => const LoginPage(); 
}