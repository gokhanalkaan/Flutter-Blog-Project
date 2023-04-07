import 'package:flutter/material.dart';

import 'package:flutter_blog_app/models/blog_model.dart';
import 'package:flutter_blog_app/models/user_model.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/profile_page.dart';
import '../pages/user_page.dart';

class Comment extends ConsumerStatefulWidget {
  const Comment({
    Key? key,
    required this.comment,
  }) : super(key: key);
  final CommentModel comment;

  @override
  ConsumerState<Comment> createState() => _CommentState();
}

class _CommentState extends ConsumerState<Comment> {
  late Future<UserModel> commentedUser;

  @override
  void initState() {
    // TODO: implement initState

    commentedUser =
        ref.read(userProvider).getUserWithId(widget.comment.userId!);
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
                Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ref.read(userProvider).userId ==
                                            _user.userId
                                        ? ProfilePage(
                                            user: _user,
                                          )
                                        : UserPage(
                                            user: _user,
                                          )),
                          );
                        }),
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(
                                  color: Colors.blueGrey.shade300, width: 2),
                              borderRadius: BorderRadius.circular(40)),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(_user.profilePhoto !=
                                    null
                                ? _user.profilePhoto!
                                : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user.username!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 3),
                            width: size.width - 70,
                            child: Text(
                              widget.comment.comment!,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.visible),
                            ),
                          ),
                        ],
                      )
                    ],
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
