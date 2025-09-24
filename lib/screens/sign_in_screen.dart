import 'dart:developer';

import 'package:chat_app/consts.dart';
import 'package:chat_app/controls/auth.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static String id = 'SignInScreen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
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
                  child: Image.asset(
                    'assets/images/forChatApp-small.jpg',
                    height: 200,
                  ),
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
                  'Sign In',
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
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await signInUser(email: email!, password: password!);

                        Navigator.pushNamed(
                          // ignore: use_build_context_synchronously
                          context,
                          ChatScreen.id,
                          arguments: email,
                        );
                        // ignore: use_build_context_synchronously
                        showSnackBarMessage(context, message: 'Wolcome ..!');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-credential') {
                          showSnackBarMessage(
                            // ignore: use_build_context_synchronously
                            context,
                            message: 'Email or password is wrong',
                          );
                        } else if (e.code == 'invalid-email') {
                          showSnackBarMessage(
                            // ignore: use_build_context_synchronously
                            context,
                            message: 'Please Enter a correct email',
                          );
                        } else if (e.code == 'network-request-failed') {
                          showSnackBarMessage(
                            // ignore: use_build_context_synchronously
                            context,
                            message: 'Check Your NetWork',
                          );
                        }
                        log(e.code.toString());
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  title: 'Sign In',
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't Have an Account?",
                      style: TextStyle(fontFamily: 'ElMessiri', fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      child: Text(
                        "  Sign Up !",
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
