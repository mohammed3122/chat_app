import 'dart:developer';

import 'package:chat_app/consts.dart';
import 'package:chat_app/controls/auth.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static String id = 'SignUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? email;
  String? password;
  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(color: Colors.blue),
      child: Scaffold(
        backgroundColor: kMainColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(height: 70),
                CircleAvatar(
                  radius: 50,
                  child: Image.asset(kLogoApp, height: 200),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Learning Chat App',
                    style: TextStyle(
                      fontFamily: 'ElMessiri',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'ElMessiri',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                CustomTextField(
                  inputType: TextInputType.emailAddress,
                  isPassword: false,
                  hintText: 'Email',
                  onChanged: (data) {
                    email = data;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.text,
                  isPassword: true,
                  hintText: 'Password',
                  hideText: true,
                  onChanged: (data) {
                    password = data;
                  },
                ),
                SizedBox(height: 30),
                CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        await signUpUser(email: email!, password: password!);

                        Navigator.pushNamed(
                          // ignore: use_build_context_synchronously
                          context,
                          ChatScreen.id,
                          arguments: email,
                        );
                        // ignore: use_build_context_synchronously
                        showSnackBarMessage(context, message: 'Sucess');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showSnackBarMessage(
                            // ignore: use_build_context_synchronously
                            context,
                            message: 'pass word is weak',
                          );
                        } else if (e.code == 'network-request-failed') {
                          showSnackBarMessage(
                            // ignore: use_build_context_synchronously
                            context,
                            message: 'Check Your NetWork',
                          );
                        } else if (e.code == 'email-already-in-use') {
                          // ignore: use_build_context_synchronously
                          showSnackBarMessage(
                            // ignore: use_build_context_synchronously
                            context,
                            message: 'email is exists',
                          );
                        }
                        log(e.code.toString());
                      }

                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  title: 'Sign Up',
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Are You Have an Account?",
                      style: TextStyle(fontFamily: 'ElMessiri', fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "  Sign In !",
                        style: TextStyle(
                          fontFamily: 'ElMessiri',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
