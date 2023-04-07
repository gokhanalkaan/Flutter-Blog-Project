import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/chat_model.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends ConsumerWidget {
  MessageModel message;

  MessageBubble(this.message);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMe =
        ref.read(userProvider).userId == message.senderId ? true : false;
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Card(
          color: isMe ? Colors.blue : Colors.deepPurple[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: size.width / 2),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              children: [
                Text(
                  message.message,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      overflow: TextOverflow.visible),
                ),
                message.createdAt != null
                    ? Align(
                        alignment: Alignment.bottomRight,
                        widthFactor: 2,
                        child: Text(
                          timeago.format(message.createdAt!.toDate()),
                          style: TextStyle(
                              color: isMe ? Colors.black : Colors.white,
                              fontSize: 11),
                        ),
                      )
                    : SizedBox(
                        height: 1,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
