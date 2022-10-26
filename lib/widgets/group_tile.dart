import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';
import '../pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupID;
  final String groupName;

  const GroupTile({
    super.key,
    required this.userName,
    required this.groupID,
    required this.groupName,
  });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextPage(
          context,
          ChatPage(
            userName: widget.userName,
            groupID: widget.groupID,
            groupName: widget.groupName,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: layout.padding / 2),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: clr.primary,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: txt.medium.copyWith(color: clr.light),
            ),
          ),
          title: Text(widget.groupName, style: txt.small.copyWith(fontWeight: FontWeight.bold)),
          subtitle: Text(widget.groupID, style: txt.small.copyWith(fontSize: txt.textSizeSmall / 1.5)),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
