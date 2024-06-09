// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  static Future<String> signIn(String email, String password) async {
    if (!email.contains('@') || !email.contains('.')) {
      return 'invalid-e-mail';
    }
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user?.uid ?? '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return e.code;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return e.code;
      }
    }
    return '';
  }

  static bool isLogged(){
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    return user != null;
  }
}
