import 'package:flutter/material.dart';

import 'package:flutter_blog_app/models/blog_model.dart';
import 'package:flutter_blog_app/models/chat_model.dart';
import 'package:flutter_blog_app/models/user_model.dart';
import 'package:flutter_blog_app/pages/messages.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatUser extends ConsumerStatefulWidget {
  const ChatUser({Key? key, required this.chat, required this.otherUserId})
      : super(key: key);
  final ChatModel chat;
  final String otherUserId;

  @override
  ConsumerState<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends ConsumerState<ChatUser> {
  late Future<UserModel> commentedUser;

  @override
  void initState() {
    // TODO: implement initState

    commentedUser = ref.read(userProvider).getUserWithId(widget.otherUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: commentedUser,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          UserModel _user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Messages(
                                userId: widget.otherUserId,
                                chatId: widget.chat.chatId,
                              )),
                    );
                  }),
                  child: Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(
                                  color: Colors.blueGrey.shade300, width: 2),
                              borderRadius: BorderRadius.circular(40)),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(_user
                                        .profilePhoto!.length >
                                    0
                                ? _user.profilePhoto!
                                : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _user.username!,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 3),
                              width: size.width - 155,
                              child: Text(
                                widget.chat.lastMessage!.length > 20
                                    ? widget.chat.lastMessage!
                                            .substring(0, 61) +
                                        "..."
                                    : widget.chat.lastMessage!,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.visible),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          timeago.format(widget.chat.updatedAt!.toDate()),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              overflow: TextOverflow.visible),
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                )
              ],
            ),
          );
        } else {
          return LinearProgressIndicator();
        }
      },

      /////////////////////////////////////////
    );
  }
}
