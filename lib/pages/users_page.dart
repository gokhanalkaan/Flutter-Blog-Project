import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_blog_app/components/user_component.dart';
import 'package:flutter_blog_app/models/user_model.dart';
import 'package:flutter_blog_app/services/user_services.dart';

class Users extends ConsumerStatefulWidget {
  final bool followers;
  final String userId;
  const Users({
    Key? key,
    required this.followers,
    required this.userId,
  }) : super(key: key);

  @override
  ConsumerState<Users> createState() => _UsersState();
}

class _UsersState extends ConsumerState<Users> {
  late Future<UserModel> user;

  @override
  void initState() {
    user = ref.read(userProvider).getUserWithId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              widget.followers == true ? Text("Followers") : Text("Followed")),
      body: FutureBuilder<UserModel>(
        future: user,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            UserModel usr = snapshot.data!;
            List<String?> _users =
                widget.followers == true ? usr.followers! : usr.followedUsers!;

            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                String? str = _users[index];

                return UserComponent(userId: str!);
              },
            );
          } else {
            return Center(
              child: Text("Problem occured"),
            );
          }
        },
      ),
    );
  }
}
