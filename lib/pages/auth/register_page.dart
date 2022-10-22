import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../../widgets/widgets.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr.light,
      body: SingleChildScrollView(
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
                  'Register to joing your friends!',
                  style: txt.medium.copyWith(
                    color: clr.darken(clr.grey, 25),
                  ),
                ),
                const SizedBox(height: layout.spacing),
                Image.asset('assets/images/register.png'),
                const SizedBox(height: layout.spacing),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: textInputDecoration.copyWith(
                      labelText: 'Name',
                      prefixIcon: const Icon(
                        Icons.person,
                        color: clr.primary,
                      ),
                    ),
                    onChanged: ((value) {
                      setState(() {
                        name = value;
                        print(name);
                      });
                    }),
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return "Please enter a name";
                      }
                    }),
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
                        return 'assword must at least 6 characters';
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
                    onPressed: register,
                    child: const Padding(
                      padding: EdgeInsets.all(layout.padding),
                      child: Text(
                        'Register',
                        style: txt.button,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: layout.spacing),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Already have an account?',
                      style: txt.small.copyWith(color: clr.darken(clr.grey, 25)),
                    ),
                    const TextSpan(text: '   '),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          nextPage(context, const LoginPage());
                          //nextPageReplace(context, const LoginPage());
                        },
                      text: 'Login',
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

  register() {}
}
