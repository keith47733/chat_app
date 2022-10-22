import 'package:chat_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_functions.dart';
import '../../services/auth_service.dart';
import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../../widgets/widgets.dart';
import '../home-page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String email = 'a@a.com';
  String password = '12345';

  AuthService authService = AuthService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr.light,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: clr.primary),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: layout.pageMarginHorizontal,
                  vertical: layout.pageMarginVertical,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Groupie',
                        style: txt.large,
                      ),
                      const SizedBox(height: layout.spacing),
                      Text(
                        'Login to see what your friends are talking about!',
                        style: txt.normal.copyWith(
                          color: clr.darken(clr.grey, 25),
                        ),
                      ),
                      const SizedBox(height: layout.spacing),
                      Image.asset('assets/images/login.png'),
                      const SizedBox(height: layout.spacing),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: textInputDecoration.copyWith(
                            labelText: 'Email',
                            prefixIcon: const Icon(
                              Icons.email,
                              color: clr.primary,
                            ),
                          ),
                          onChanged: ((value) {
                            setState(() {
                              email = value;
                              print(email);
                            });
                          }),
                          validator: (value) {
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : 'Please enter a valid email';
                          }),
                      const SizedBox(height: layout.spacing),
                      TextFormField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                            labelText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: clr.primary,
                            ),
                          ),
                          onChanged: ((value) {
                            setState(() {
                              password = value;
                              print(password);
                            });
                          }),
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Pleae enter a password with at least 6 characters';
                            } else {
                              return null;
                            }
                          }),
                      const SizedBox(height: layout.spacing * 2),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(layout.radius * 1.5),
                            ),
                          ),
                          onPressed: () => login(),
                          child: const Padding(
                            padding: EdgeInsets.all(layout.padding),
                            child: Text(
                              'Sign In',
                              style: txt.button,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: layout.spacing),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Don\'t have an account?',
                            style: txt.small.copyWith(color: clr.darken(clr.grey, 25)),
                          ),
                          const TextSpan(text: '     '),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextPage(context, const RegisterPage());
                              },
                            text: 'Register here',
                            style: txt.textButton,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService.loginUserWithEmailAndPassword(email, password).then((value) async {
        if (value == true) {
					QuerySnapshot snapshot = await DatabaseService(FirebaseAuth.instance.currentUser!.uid)
					.getUserData(email);
          await HelperFunctions.saveUserLoggedInStatusSF(true);
          await HelperFunctions.saveUserNameSF(email);
          await HelperFunctions.saveUserEmailSF(snapshot.docs[0]['user_email']);
          nextPageReplace(context, const HomePage());
        } else {
          showSnackBar(
            context,
            value,
            clr.dark.withOpacity(0.5),
          );
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
