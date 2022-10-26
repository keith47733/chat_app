import 'package:flutter/material.dart';

import '../shared/clr.dart';
import 'pages/auth/login_page.dart';
import 'pages/my_groups.dart';
import 'services/shared_pref.dart';

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
    await SharedPref.getUserLoggedInStatusFromSF().then((value) {
      if (value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: clr.primary,
      ),
      home: _isLoggedIn ? const MyGroups() : const LoginPage(),
    );
  }
}
