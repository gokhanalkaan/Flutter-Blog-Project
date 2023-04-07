import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog_app/models/user_model.dart';
import 'package:flutter_blog_app/pages/profile_page.dart';
import 'package:flutter_blog_app/pages/user_page.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserComponent extends ConsumerStatefulWidget {
  const UserComponent({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  ConsumerState<UserComponent> createState() => _UserComponentState();
}

class _UserComponentState extends ConsumerState<UserComponent> {
  late Future<UserModel> user;

  @override
  void initState() {
    user = ref.read(userProvider).getUserWithId(widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<UserModel>(
      future: user,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          UserModel usr = snapshot.data!;
          return Column(
            children: [
              GestureDetector(
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ref.read(userProvider).userId == widget.userId
                                ? ProfilePage(
                                    user: usr,
                                  )
                                : UserPage(
                                    user: usr,
                                  )),
                  );
                }),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                    color: Colors.blueGrey.shade300, width: 2),
                                borderRadius: BorderRadius.circular(40)),
                            margin: EdgeInsets.only(right: 3),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(usr!
                                          .profilePhoto!.length >
                                      0
                                  ? usr.profilePhoto!
                                  : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                            )),
                        SizedBox(
                          width: 3,
                        ),
                        Text(user != null ? usr.username! : "Username")
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
            ],
          );
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }
}
