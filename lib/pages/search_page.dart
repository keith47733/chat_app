import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/widgets/widgets.dart';

import '../services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../../services/database_service.dart';
import '../helper/helper_functions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = '';
  User? user;
  bool hasJoinedGroup = false;

  @override
  void initState() {
    getCurrentUserIDandName();
    super.initState();
  }

  getCurrentUserIDandName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
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
        elevation: layout.elevation,
        centerTitle: true,
        title: const Text(
          'Search Groups',
          style: txt.appBar,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: clr.primary,
            padding: const EdgeInsets.all(layout.padding / 2),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: txt.normal.copyWith(color: clr.light),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search groups...',
                      hintStyle: txt.small.copyWith(color: clr.light),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: initiateSearch,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: clr.light.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(layout.radius),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: clr.light,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading ? const Center(child: CircularProgressIndicator()) : groupList(),
        ],
      ),
    );
  }

  initiateSearch() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchGroupsByName(searchController.text).then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: ((context, index) {
              return searchGroupTile(
                userName,
                searchSnapshot!.docs[index]['group_id'],
                searchSnapshot!.docs[index]['group_name'],
                searchSnapshot!.docs[index]['admin'],
              );
            }),
          )
        : Container();
  }

  searchGroupTile(String userName, String groupID, String groupName, String admin) {
    isInGroup(userName, groupID, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.all(layout.padding),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: clr.primary,
        child: Text(groupName.substring(0, 1).toUpperCase(), style: txt.medium.copyWith(color: clr.light)),
      ),
      title: Text(groupName, style: txt.normal),
      subtitle: Text('${getName(admin)}', style: txt.small),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupID, userName, groupName);
          if (hasJoinedGroup) {
            setState(() {
              hasJoinedGroup = !hasJoinedGroup;
            });
            showSnackBar(context, 'Successfully joined group', clr.confirm);
            Future.delayed(const Duration(seconds: 2), () {
              nextPage(context, ChatPage(currentUserName: userName, groupID: groupID, groupName: groupName));
            });
          } else {
            setState(() {
              hasJoinedGroup = !hasJoinedGroup;
            });
            showSnackBar(context, 'Successfully left $groupName', clr.error);
          }
        },
        child: hasJoinedGroup
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
    );
  }

  isInGroup(String userName, String groupID, String groupName, String admin) {
    DatabaseService(uid: user!.uid).isUserInGroup(groupID, groupName, userName).then((value) {
      setState(() {
        hasJoinedGroup = value;
      });
    });
  }
}
