import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';

import '../../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authService.logout();
          },
          child: const Text('LOGOUT'),
        ),
      ),
    );
  }
}
