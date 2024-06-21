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
        return e.code;
      } else if (e.code == 'wrong-password') {
        return e.code;
      }
    }
    return '';
  }

  static void signOut() {
    FirebaseAuth.instance.signOut();
  }

  static bool isLogged(){
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  static User? getCurrentUser(){
    return FirebaseAuth.instance.currentUser;
  }
}
