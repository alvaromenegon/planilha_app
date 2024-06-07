import 'package:flutter/material.dart';
import 'package:planilla_android/app/pages/splash/presenter/splash_presenter.dart';

class SplashPage extends StatefulWidget{
  final SplashPresenter presenter;
  const SplashPage({super.key,required this.presenter});
  
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );    
  }
}