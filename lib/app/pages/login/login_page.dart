// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/input.dart';
import 'package:planilla_android/app/core/ui/components/password_input.dart';
import 'package:planilla_android/app/services/firebase/firebase_authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  String message = '';

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Input(
                label: 'E-mail',
                value: email,
                onChanged: (value) => email = value),
            PasswordInput(
                label: 'Senha',
                value: password,
                onChanged: (value) => password = value),
            Button.primary(
                label: 'Entrar',
                onPressed: () => {
                      if (email.isNotEmpty && password.isNotEmpty)
                        {
                          FirebaseAuthServices.signIn(email, password)
                              .then((value) {
                            if (value == 'user-not-found') {
                              message = 'No user found for that email.';
                            } else if (value == 'wrong-password') {
                              message =
                                  'Wrong password provided for that user.';
                            } else if (value.isEmpty) {
                              message = 'An error occurred.';
                            } else if (value == 'invalid-e-mail') {
                              message = 'Invalid e-mail.';
                            } else {
                              message = '';
                              print('User ID: $value');
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          })
                        } else {message = 'Fill in all fields.'}
                    }),
            if (message.isNotEmpty)
              Text(style: const TextStyle(color: Colors.red), message),
          ],
        ),
      ),
    );
  }
}
