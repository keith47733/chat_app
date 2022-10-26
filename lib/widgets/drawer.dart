import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../pages/auth/login_page.dart';
import '../pages/groups.dart';
import '../pages/my_groups.dart';
import '../pages/profile_page.dart';
import '../services/auth_service.dart';
import 'widgets.dart';

Widget appDrawer(
  BuildContext context,
  String currentPage,
  String userName,
) {
  AuthService authService = AuthService();
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.symmetric(vertical: layout.pageMarginVertical),
      children: [
        const Center(
          child: CircleAvatar(
            radius: 75,
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
        ),
        const SizedBox(height: layout.spacing),
        Text(
          userName,
          textAlign: TextAlign.center,
          style: txt.medium,
        ),
        const SizedBox(height: layout.spacing),
        const Divider(height: 2),
        ListTile(
          onTap: () => nextPageReplace(context, const MyGroups()),
          selectedColor: clr.primary,
          selected: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: layout.padding),
          leading: const Icon(Icons.group),
          title: const Text('My Groups', style: txt.normal),
        ),
        ListTile(
          onTap: () => nextPageReplace(context, const Groups()),
          selectedColor: clr.primary,
          selected: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: layout.padding),
          leading: const Icon(Icons.person),
          title: const Text('Groups', style: txt.normal),
        ),
        ListTile(
          onTap: () => nextPageReplace(context, ProfilePage(userName: userName)),
          selectedColor: clr.primary,
          selected: false,
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
                  title: Text(
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
          selected: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: layout.padding),
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout', style: txt.normal),
        ),
      ],
    ),
  );
}
