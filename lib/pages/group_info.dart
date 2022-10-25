import 'package:chat_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';

class GroupInfo extends StatefulWidget {
  final String groupAdmin;
  final String groupID;
  final String groupName;

  const GroupInfo({
    super.key,
    required this.groupAdmin,
    required this.groupID,
    required this.groupName,
  });

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    getGroupMembers();
    super.initState();
  }

  getGroupMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupMembers(widget.groupID).then((value) {
      setState(() {
        members = value;
      });
    });
  }

  getGroupID(String ID) {
    return ID.substring(0, ID.indexOf('_'));
  }

  getName(String name) {
    return name.substring(name.indexOf('_') + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Group Info',
          style: txt.appBar,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(layout.padding),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(layout.padding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(layout.radius),
                color: clr.primary.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: clr.primary,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: txt.medium.copyWith(color: clr.light),
                    ),
                  ),
                  const SizedBox(width: layout.spacing),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Group:  ${widget.groupName}', style: txt.normal),
                      const SizedBox(height: layout.spacing / 3),
                      Text('Admin:  ${getName(widget.groupAdmin)}', style: txt.small),
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: layout.padding),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: clr.primary,
                        child: Text(
                          //'#',
													getName(snapshot.data['members'][index]).substring(0, 1).toUpperCase(),
                          textAlign: TextAlign.center,
                          style: txt.medium.copyWith(color: clr.light),
                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index]), style: txt.normal),
                      subtitle: Text(getGroupID(snapshot.data['members'][index]), style: txt.small.copyWith(fontSize: txt.textSizeSmall / 1.25)),
                    ),
                  );
                },
              );
            } else {
              return const Text('This group does not have any members yet.', style: txt.normal);
            }
          } else {
            return const Text('This group does not have any members yet.', style: txt.normal);
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
