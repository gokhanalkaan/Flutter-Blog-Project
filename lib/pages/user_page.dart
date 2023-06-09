import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/pages/messages.dart';
import 'package:flutter_blog_app/pages/users_page.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_blog_app/components/blog.dart';
import 'package:flutter_blog_app/components/bottom_navbar.dart';
import 'package:flutter_blog_app/models/blog_model.dart';
import 'package:flutter_blog_app/models/user_model.dart';
import 'package:flutter_blog_app/services/blog_services.dart';

class UserPage extends ConsumerStatefulWidget {
  UserModel? user;

  UserPage({this.user}) : super();

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  late Future<List<BlogModel>> val;
  UserModel? _foundedUser;
  late int followers;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    val = (selectedIndex == 0
        ? ref.read(blogProvider).getUserBlog(widget.user!.userId)
        : ref.read(blogProvider).getUserLikedBlog(widget.user!.userId!));

    followers = widget.user!.followers!.length;

    // getUserBlog();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _followedUsers = ref.watch(userProvider).followedUsers;
    bool isFollowed = _followedUsers.contains(widget.user!.userId!);
    debugPrint("followed" + isFollowed.toString());
    Size size = MediaQuery.of(context).size;

    String userId = widget.user!.userId!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Blogify"),
        // automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(widget
                                      .user!.profilePhoto!.length >
                                  0
                              ? widget.user!.profilePhoto!
                              : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png")),
                    ),
                  ),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          widget.user!.username!,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: size.width / 2 - 10,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Users(
                                            followers: false,
                                            userId: widget.user!.userId!)),
                                  );
                                },
                                child: Text(
                                    "${widget.user?.followedUsers?.length.toString()} followed")),
                          ),
                          Container(
                            width: size.width / 2 - 10,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Users(
                                              followers: true,
                                              userId: widget.user!.userId!,
                                            )),
                                  );
                                },
                                child: Text(
                                    followers.toString() + " " + "followers")),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 36),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  if (isFollowed) {
                                    ref
                                        .read(userProvider)
                                        .unfollowUser(widget.user!.userId!);

                                    if (followers > 0) {
                                      setState(() {
                                        followers = followers - 1;
                                      });
                                    }
                                  } else {
                                    ref
                                        .read(userProvider)
                                        .followUser(widget.user!.userId!);
                                    setState(() {
                                      followers = followers + 1;
                                    });
                                  }
                                },
                                child: isFollowed
                                    ? Text("Unfollow")
                                    : Text("Follow")),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Messages(
                                              userId: userId,
                                            )),
                                  );
                                },
                                icon: Icon(
                                  Icons.message,
                                  color: Color.fromARGB(255, 0, 127, 185),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4, left: 4),
                        child: Container(
                          width: size.width / 2 - 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Divider(
                                color: selectedIndex == 0
                                    ? Colors.blue.shade600
                                    : Colors.blue.shade100,
                                thickness: 2,
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (selectedIndex != 0) {
                                        selectedIndex = 0;
                                        val = ref
                                            .read(blogProvider)
                                            .getUserBlog(widget.user!.userId!);
                                      }
                                    });
                                  },
                                  child: Text(
                                    "Posts",
                                    style: TextStyle(
                                        color: selectedIndex == 0
                                            ? Colors.blue.shade600
                                            : Colors.blue.shade100),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: Container(
                          width: size.width / 2 - 10,
                          child: Column(
                            children: [
                              Divider(
                                  color: selectedIndex == 1
                                      ? Colors.blue.shade600
                                      : Colors.blue.shade100),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (selectedIndex != 1) {
                                        selectedIndex = 1;
                                        val = ref
                                            .read(blogProvider)
                                            .getUserLikedBlog(
                                                widget.user!.userId!);
                                      }
                                    });
                                  },
                                  child: Text("Likes",
                                      style: TextStyle(
                                          color: selectedIndex == 1
                                              ? Colors.blue.shade600
                                              : Colors.blue.shade100)))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                      child: FutureBuilder<List<BlogModel>>(
                    future: val,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<BlogModel> blogs = snapshot.data!;
                        return ListView.builder(
                            itemCount: blogs.length,
                            itemBuilder: ((BuildContext context, int index) {
                              BlogModel model = blogs[index];
                              debugPrint(model.blogId);
                              debugPrint(model.blogImage);
                              debugPrint(model.blogQuote);
                              debugPrint(model.blogTitle);
                              debugPrint(model.creatorId);
                              debugPrint("likes page liked" +
                                  model.likedUsers!.length.toString());

                              return Blog(
                                blog: model,
                                likeCount: model.likedUsers!.length,
                              );
                            }));
                      } else if (!snapshot.hasData) {
                        return Center(
                          child: Text("No Blog"),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ))
                ],
              ),
            ),
            BottomNavbar()
          ],
        ),
      ),
    );
  }
}
