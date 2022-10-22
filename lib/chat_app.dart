import 'package:chat_app/helper/helper_functions.dart';
import 'package:flutter/material.dart';

import '../shared/clr.dart';
import 'pages/auth/login_page.dart';
import 'pages/home-page.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        _isLoggedIn = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: clr.primaryColor,
      ),
      home: _isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
