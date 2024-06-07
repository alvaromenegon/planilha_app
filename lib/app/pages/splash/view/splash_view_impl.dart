import 'package:flutter/material.dart';
import 'package:planilla_android/app/pages/splash/view/splash_view.dart';

import './splash_page.dart';

abstract class SplashViewImpl extends State<SplashPage> implements SplashView {
  @override
  void initState() {
    widget.presenter.view = this;
    super.initState();    
  }
 
  @override
  void isLogged(bool isLogged) {
    if (isLogged) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/auth/login', (route) => false);
    }
  }

  @override
  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
