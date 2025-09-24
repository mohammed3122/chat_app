import 'package:firebase_auth/firebase_auth.dart';

// SignUp Method:
Future<UserCredential> signUpUser({
  required String email,
  required String password,
}) async {
  UserCredential user = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
  return user;
}

// SignIn Method:
Future<UserCredential> signInUser({
  required String email,
  required String password,
}) async {
  UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  return user;
}
