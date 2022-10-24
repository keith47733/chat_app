import 'package:chat_app/services/database_service.dart';
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
  Stream? groups;
  bool _isLoading = false;
  String groupName = '';

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

    await DatabaseService(FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot) {
      setState(() {
        groups = snapshot;
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
              contentPadding: const EdgeInsets.symmetric(horizontal: layout.padding),
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout', style: txt.normal),
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addGroupDialog(context),
        backgroundColor: clr.primary,
        foregroundColor: clr.light,
        child: const Icon(Icons.group_add_sharp, size: layout.spacing * 1.5, color: clr.light),
      ),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return const Text('HELLO');
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return const Center(child: CircularProgressIndicator(color: clr.primary));
        }
      },
    );
  }

  addGroupDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Create a group',
              textAlign: TextAlign.center,
              style: txt.medium,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
							crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isLoading == true
                    ? const Center(child: CircularProgressIndicator(color: clr.primary))
                    : TextField(
                        onChanged: (value) {
                          setState(() {
                            groupName = value;
                          });
                        },
                        style: txt.small,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: clr.primary),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: clr.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: clr.error),
                          ),
                        ),
                      ),
              ],
            ),
            actions: [
              Row(
								mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(layout.radius / 2),
                      ),
                    ),
                    onPressed: () {
											Navigator.of(context).pop();
										},
                    child: Padding(
                      padding: const EdgeInsets.all(layout.padding / 2),
                      child: Text(
                        'Cancel',
                        style: txt.button.copyWith(fontSize: txt.textSizeSmall),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(layout.radius / 2),
                      ),
                    ),
                    onPressed: () async {
											if(groupName != '') {
												setState(() {
												  _isLoading = true;
													DatabaseService(FirebaseAuth.instance.currentUser!.uid).createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName)
													.whenComplete(() => _isLoading = false);
												});
												Navigator.of(context).pop();
												showSnackBar(context, 'Group created successfully', clr.confirm);
											} else {
												
											}
										},
                    child: Padding(
                      padding: const EdgeInsets.all(layout.padding / 2),
                      child: Text(
                        'Create',
                        style: txt.button.copyWith(fontSize: txt.textSizeSmall),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  noGroupWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: layout.padding * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.groups, size: 75, color: clr.grey2),
          const SizedBox(height: layout.spacing),
          Text('You have not created or joined any groups yet.',
              textAlign: TextAlign.center, style: txt.normal.copyWith(color: clr.grey2)),
        ],
      ),
    );
  }
}
