import 'package:flutter/material.dart';

import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../widgets/drawer.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final String userName;

  const ProfilePage({
    super.key,
    required this.userName,
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
      drawer: appDrawer(context, 'MyGroups', 'IMPLEMENT USERNAME IN DRAWER WIDGET'),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: layout.pageMarginVertical,
          horizontal: layout.pageMarginHorizontal,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 75,
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
            ),
            const SizedBox(height: layout.spacing * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Name',
                  style: txt.normal,
                ),
                Text(
                  widget.userName,
                  style: txt.normal,
                ),
              ],
            ),
            const Divider(height: layout.spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Email',
                  style: txt.normal,
                ),
                // Text(
                //   widget.userEmail,
                //   style: txt.normal,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
