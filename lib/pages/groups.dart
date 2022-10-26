import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../services/database_service.dart';
import '../services/shared_pref.dart';
import '../widgets/drawer.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  User? user;

  String uid = '';
  String userName = '';
  String groupId = '';
  String groupName = '';

  bool isLoading = false;
  bool isInGroup = false;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;

    await SharedPref.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  String getGroupName(String groupName) {
    return groupName.substring(groupName.indexOf('_') + 1);
  }

  String getAdminName(String adminName) {
    return adminName.substring(adminName.indexOf('_') + 1);
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
      ),
      drawer: appDrawer(context, 'Groups', userName),
			body: groupList(),
    );
  }

  groupList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('groups').orderBy('group_name', descending: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data?.docs.isNotEmpty == true) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((BuildContext context, int index) {
                //int reverseIndex = snapshot.data?.docs.length - index - 1;
                return groupTile(
                  groupID: snapshot.data.docs[index]['group_id'],
                  groupName: getGroupName(snapshot.data.docs[index]['group_name']),
                  adminName: getAdminName(snapshot.data.docs[index]['admin']),
                );
              }),
            );
          } else {
            return noGroups();
          }
        });
  }

  groupTile({
    required String groupID,
    required String groupName,
    required String adminName,
  }) {
    checkGroup(groupID, groupName);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: layout.padding, vertical: layout.padding / 2),
      padding: const EdgeInsets.all(layout.padding / 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(layout.radius),
        color: clr.primary.withOpacity(0.2),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: clr.primary,
          child: Text(groupName.substring(0, 1).toUpperCase(), style: txt.medium.copyWith(color: clr.light)),
        ),
        title: Text(groupName, style: txt.normal),
        subtitle: Text(adminName, style: txt.small),
        trailing: InkWell(
          onTap: () async {
            // await DatabaseService(uid: user!.uid).toggleGroupJoin(groupID, userName, groupName);
            // if (hasJoinedGroup) {
            //   setState(() {
            //     hasJoinedGroup = !hasJoinedGroup;
            //   });
            //   showSnackBar(context, 'Successfully joined group', clr.confirm);
            //   Future.delayed(const Duration(seconds: 2), () {
            //     nextPage(context, ChatPage(currentUserName: userName, groupID: groupID, groupName: groupName));
            //   });
            // } else {
            //   setState(() {
            //     hasJoinedGroup = !hasJoinedGroup;
            //   });
            //   showSnackBar(context, 'Successfully left $groupName', clr.error);
            // }
          },
          child: isInGroup
              ? Container(
                  padding: const EdgeInsets.all(layout.padding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(layout.radius),
                    color: clr.dark,
                    border: Border.all(color: clr.light, width: 1),
                  ),
                  child: Text('Joined', style: txt.small.copyWith(color: clr.light)))
              : Container(
                  padding: const EdgeInsets.all(layout.padding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(layout.radius),
                    color: clr.primary,
                  ),
                  child: Text('Join', style: txt.small.copyWith(color: clr.light))),
        ),
      ),
    );
  }

  checkGroup(String groupID, String groupName) {
    DatabaseService(uid: user!.uid).isUserInGroup(groupID, groupName, userName).then((value) {
      setState(() {
        isInGroup = value;
      });
    });
  }

  noGroups() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: layout.padding * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.groups, size: 75, color: clr.grey2),
          const SizedBox(height: layout.spacing),
          Text('A group has not been created yet.',
              textAlign: TextAlign.center, style: txt.normal.copyWith(color: clr.grey2)),
        ],
      ),
    );
  }
}
