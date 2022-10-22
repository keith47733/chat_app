import 'package:chat_app/pages/home-page.dart';
import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../widgets/widgets.dart';
import '../services/auth_service.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: txt.appBar,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: layout.pageMarginVertical),
          children: [
            const Icon(
              Icons.account_circle,
              size: 150,
              color: clr.primary,
            ),
            const SizedBox(height: layout.spacing),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: txt.medium,
            ),
            const SizedBox(height: layout.spacing),
            const Divider(height: 2),
            ListTile(
              onTap: () => nextPageReplace(context, const HomePage()),
              selectedColor: clr.primary,
              contentPadding: const EdgeInsets.symmetric(horizontal: layout.padding),
              leading: const Icon(Icons.group),
              title: const Text('Groups', style: txt.normal),
            ),
            ListTile(
              onTap: () {},
              selected: true,
              selectedColor: clr.primary,
              contentPadding: const EdgeInsets.symmetric(horizontal: layout.padding),
              leading: const Icon(Icons.person),
              title: const Text('Profile', style: txt.normal),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                      title: const Text(
                        'Logout',
                        style: txt.medium,
                      ),
                      content: const Text(
                        'Are you sure you want to logout?',
                        style: txt.normal,
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: clr.error,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authService.logout();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                            );
                          },
                          icon: Icon(
                            Icons.exit_to_app,
                            color: clr.confirm,
                          ),
                        ),
                      ],
                    );
                  }),
                );
              },
              selectedColor: clr.primary,
              contentPadding: const EdgeInsets.symmetric(horizontal: layout.padding),
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout', style: txt.normal),
            ),
          ],
        ),
      ),
    );
  }
}
