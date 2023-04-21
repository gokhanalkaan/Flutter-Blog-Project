import 'package:flutter/material.dart';

import 'package:flutter_blog_app/models/blog_model.dart';
import 'package:flutter_blog_app/models/user_model.dart';
import 'package:flutter_blog_app/pages/profile_page.dart';
import 'package:flutter_blog_app/pages/single_blog_page.dart';
import 'package:flutter_blog_app/services/blog_services.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/user_page.dart';

class Blog extends ConsumerStatefulWidget {
  Blog({Key? key, required this.blog, this.likeCount}) : super(key: key);

  BlogModel blog;
  int? likeCount;

  @override
  ConsumerState<Blog> createState() => _BlogState();
}

class _BlogState extends ConsumerState<Blog> {
  late Future<UserModel> _blogOwner;
  late int like = widget.blog.likedUsers!.length;
  //late List<String> likedPosts;
  // late int like;

  @override
  void initState() {
    //  debugPrint("blog like" + like.toString());
    // like = widget.blog.likedUsers!.length;
    super.initState();

    like = widget.likeCount!;

    _blogOwner = ref.read(userProvider).getUserWithId(widget.blog.creatorId!);
    // likedPosts = ref.read(blogProvider).currentUserLikedPost;
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("rendered  " + widget.blog.blogTitle! + like.toString());
    List<Map<String, dynamic>> likedPosts =
        ref.watch(blogProvider).currentUserLikedPost;
    // like = widget.blog.likedUsers!.length;
    // print(" curr user liked posts:" + likedPosts.toString());

    debugPrint("blog like count " + like.toString());

    print(" curr user liked post length" + likedPosts.length.toString());

    int commentCount = widget.blog.comments!.length;

    print("liked posts []" + likedPosts.toString());
    //bool postLiked = likedPosts.contains(widget.blog.blogId);

    var post =
        likedPosts.where((p) => p["blogId"] == widget.blog.blogId).toList();
    print("post" + post.toString());
    bool postLiked = post.isNotEmpty ? true : false;

    if (postLiked) {
      like = post.first["likeCount"];
    }

    debugPrint("post liked" + postLiked.toString());

    debugPrint(widget.blog.comments!.length.toString());

    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.all(10),
        height: size.height / 2 + 32,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 2),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SingleBlogPage(
                                blog: widget.blog,
                                blogOwner: _blogOwner,
                                func: () {
                                  setState(() {
                                    commentCount++;
                                  });
                                },
                              )),
                    );
                  },
                  child: Image.network(
                    widget.blog.blogImage!,
                    fit: BoxFit.contain,
                    height: size.height / 2 - 75,
                    width: size.width,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    widget.blog.blogTitle!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 4),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (postLiked == false) {
                              ref
                                  .read(blogProvider.notifier)
                                  .likePost(widget.blog.blogId!, like);

                              setState(() {
                                like += 1;
                                postLiked = true;
                              });
                            } else {
                              if (like > 0) {
                                bool res = await ref
                                    .read(blogProvider.notifier)
                                    .removeLike(widget.blog.blogId!);

                                if (res == true) {
                                  setState(() {
                                    like -= 1;

                                    //postLiked = false;
                                    // postLiked = false;
                                  });
                                }
                              } else {
                                return;
                              }
                            }
                          },
                          icon: Icon(
                            Icons.star,
                            color: postLiked
                                ? Colors.yellow.shade700
                                : Colors.grey.shade700,
                          ),
                        ),
                        Text(like.toString(),
                            style: const TextStyle(fontSize: 10))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 4),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleBlogPage(
                                        blog: widget.blog,
                                        blogOwner: _blogOwner,
                                        func: () {
                                          setState(() {
                                            commentCount++;
                                          });
                                        },
                                      )),
                            );
                          },
                          icon: Icon(Icons.comment),
                        ),
                        Text(commentCount.toString(),
                            style: const TextStyle(fontSize: 10))
                      ],
                    ),
                  ),
                ],
              ),
              FutureBuilder<UserModel>(
                  future: _blogOwner,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserModel _user = snapshot.data!;
                      return Row(
                        children: [
                          Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(
                                      color: Colors.blueGrey.shade300,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(40)),
                              margin: EdgeInsets.only(right: 3),
                              child: GestureDetector(
                                onTap: (() async {
                                  UserModel? _foundedUser;
                                  _foundedUser = await ref
                                      .read(userProvider)
                                      .getUserWithId(widget.blog.creatorId!);
                                  print("profile page founded user:" +
                                      _foundedUser.userId!);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ref.read(userProvider).userId ==
                                                    _foundedUser!.userId
                                                ? ProfilePage(
                                                    user: _foundedUser,
                                                  )
                                                : UserPage(
                                                    user: _foundedUser,
                                                  )),
                                  );
                                }),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(_user
                                              .profilePhoto!.length >
                                          0
                                      ? _user.profilePhoto!
                                      : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                                ),
                              )),
                          Text(_user.username!,
                              style: const TextStyle(fontSize: 10))
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.shade200,
              ),
            ],
          ),
        ));
  }
}
