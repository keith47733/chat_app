import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';

class MessageTile extends StatefulWidget {
  final String sender;
  final String message;
  final bool sentByMe;

  const MessageTile({
    super.key,
    required this.sender,
    required this.message,
    required this.sentByMe,
  });

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.sentByMe
          ? const EdgeInsets.only(
              top: layout.spacing / 2,
              bottom: layout.spacing / 2,
              left: layout.spacing * 4,
              right: layout.spacing / 4,
            )
          : const EdgeInsets.only(
              top: layout.spacing / 2,
              bottom: layout.spacing / 2,
              left: layout.spacing / 4,
              right: layout.spacing * 4,
            ),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(layout.padding),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(layout.radius),
                  topRight: Radius.circular(layout.radius),
                  bottomLeft: Radius.circular(layout.radius),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(layout.radius),
                  topRight: Radius.circular(layout.radius),
                  bottomRight: Radius.circular(layout.radius),
                ),
          color: widget.sentByMe ? clr.primary : clr.grey2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.sender,
                textAlign: TextAlign.left, style: txt.normal.copyWith(color: clr.light, fontWeight: FontWeight.bold)),
            const SizedBox(height: layout.spacing / 4),
            Text(
              widget.message,
              textAlign: TextAlign.left,
              style: txt.small.copyWith(color: clr.light),
            ),
          ],
        ),
      ),
    );
  }
}
