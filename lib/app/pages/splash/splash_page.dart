import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/services/firebase/firebase_authentication.dart';
//import 'package:planilla_android/app/pages/splash/presenter/splash_presenter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key,});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Button.primary(
          label: 'Entrar',
          onPressed: () {
            if (FirebaseAuthServices.isLogged()) {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            } else {
              Navigator.pushNamed(context, '/auth/login');
            }
          },
        ),
      ),
    );
  }
}
