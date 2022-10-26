import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/database_service.dart';
import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../../widgets/widgets.dart';
import '../services/shared_pref.dart';
import '../widgets/drawer.dart';
import '../widgets/group_tile.dart';
import 'search_page.dart';

class MyGroups extends StatefulWidget {
  const MyGroups({super.key});

  @override
  State<MyGroups> createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
  String userName = '';
  String userEmail = '';

  Stream? groups;
  bool _isLoading = false;
  String groupName = '';

  @override
  void initState() {
    super.initState();
    userDataGetter();
  }

  String getGroupId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String getGroupName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  userDataGetter() async {
    await SharedPref.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    await SharedPref.getUserEmailFromSF().then((value) {
      setState(() {
        userEmail = value!;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot) {
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
          'My Groups',
          style: txt.appBar,
        ),
        actions: [
          IconButton(
            onPressed: () => nextPage(context, const SearchPage()),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: appDrawer(context, 'MyGroups', userName),
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
    return Padding(
      padding: const EdgeInsets.all(layout.padding / 2),
      child: StreamBuilder(
        stream: groups,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: ((context, index) {
                    int reverseIndex = snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                      userName: userName,
                      groupID: getGroupId(snapshot.data['groups'][reverseIndex]),
                      groupName: getGroupName(snapshot.data['groups'][reverseIndex]),
                    );
                  }),
                );
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
      ),
    );
  }

  addGroupDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: ((context, setState) {
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
                          if (groupName != '') {
                            setState(() {
                              _isLoading = true;
                              DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                  .createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName)
                                  .whenComplete(() => _isLoading = false);
                            });
                            Navigator.of(context).pop();
                            showSnackBar(context, 'Group created successfully', clr.confirm);
                          } else {}
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
            }),
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
