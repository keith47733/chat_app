import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/txt.dart';
import '../../widgets/widgets.dart';
import '../services/database_service.dart';
import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final String currentUserName;
  final String groupID;
  final String groupName;

  const ChatPage({
    super.key,
    required this.currentUserName,
    required this.groupID,
    required this.groupName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = '';

  @override
  void initState() {
    getChatData();
    super.initState();
  }

  getChatData() {
    DatabaseService().getChats(widget.groupID).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupID).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.groupName,
          style: txt.appBar,
        ),
        actions: [
          IconButton(
            onPressed: () {
              nextPage(
                context,
                GroupInfo(
                  groupAdmin: admin,
                  groupID: widget.groupID,
                  groupName: widget.groupName,
                ),
              );
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
    );
  }
}
