import 'package:chat_app/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../../widgets/widgets.dart';
import '../services/database_service.dart';
import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String groupID;
  final String groupName;

  const ChatPage({
    super.key,
    required this.userName,
    required this.groupID,
    required this.groupName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = '';

  @override
  void initState() {
    getChatMessages();
    super.initState();
  }

  getChatMessages() {
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
      body: Stack(
        children: [
          buildChatMessages(),
          messageInput(),
        ],
      ),
    );
  }

	Widget messageInput() {
		return Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.all(layout.padding),
              color: clr.primary,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: txt.small.copyWith(color: clr.light),
                      decoration: InputDecoration(
                        hintText: 'Send a message...',
                        hintStyle: txt.normal.copyWith(color: clr.light),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: layout.spacing),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: clr.light.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(layout.radius),
                      ),
                      child: const Icon(Icons.send, color: clr.light),
                    ),
                  ),
                ],
              ),
            ),
          );
	}

  buildChatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      sender: snapshot.data.docs[index]['sender'],
                      message: snapshot.data.docs[index]['message'],
                      sentByMe: widget.userName == snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        'message': messageController.text,
        'sender': widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
			DatabaseService().sendMessage(widget.groupID, chatMessageMap);
			setState(() {
			  messageController.clear();
			});
    }
  }
}
