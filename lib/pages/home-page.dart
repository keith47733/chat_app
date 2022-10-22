import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../../widgets/widgets.dart';
import '../helper/helper_functions.dart';
import '../services/auth_service.dart';
import 'auth/login_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  String userEmail = '';
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    userDataGetter();
  }

  userDataGetter() async {
    await HelperFunctions.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    await HelperFunctions.getUserEmailSF().then((value) {
      setState(() {
        userEmail = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Groups',
          style: txt.appBar,
        ),
        actions: [
          IconButton(
            onPressed: () => nextPage(context, const SearchPage()),
            icon: const Icon(Icons.search),
          ),
        ],
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
              userName,
              textAlign: TextAlign.center,
              style: txt.medium,
            ),
            const SizedBox(height: layout.spacing),
            const Divider(height: 2),
            ListTile(
              onTap: () {},
              selectedColor: clr.primary,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: layout.padding),
              leading: const Icon(Icons.group),
              title: const Text('Groups', style: txt.normal),
            ),
            ListTile(
              onTap: () => nextPageReplace(context, ProfilePage(userName: userName, userEmail: userEmail)),
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
