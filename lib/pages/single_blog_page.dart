import 'package:flutter/material.dart';

import 'package:flutter_blog_app/components/comment.dart';
import 'package:flutter_blog_app/components/comments.dart';
import 'package:flutter_blog_app/models/blog_model.dart';
import 'package:flutter_blog_app/models/user_model.dart';
import 'package:flutter_blog_app/services/blog_services.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleBlogPage extends ConsumerStatefulWidget {
  SingleBlogPage({
    Key? key,
    required this.func,
    required this.blogOwner,
    required this.blog,
  }) : super(key: key);

  final dynamic blogOwner;

  final Function func;
  BlogModel blog;

  @override
  ConsumerState<SingleBlogPage> createState() => _SingleBlogPageState();
}

class _SingleBlogPageState extends ConsumerState<SingleBlogPage> {
  late TextEditingController _controller;
  late List<CommentModel>? allComments;
  bool isCommentOpened = false;

  @override
  void initState() {
    _controller = TextEditingController();
    allComments = widget.blog.comments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.blog.comments?.length.toString());
    debugPrint("iscommentopened:" + isCommentOpened.toString());

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.red),
                    height: size.height - 180,
                    width: size.height,
                    child: Image.network(
                      widget.blog.blogImage!,
                      fit: BoxFit.fill,
                      // color: Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      widget.blog.blogTitle!,
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      widget.blog.blogQuote!,
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  isCommentOpened == false
                      // ignore: dead_code
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              isCommentOpened = true;
                            });
                          },
                          child: Row(
                            children: [
                              Text(widget.blog.comments!.length.toString() +
                                  " comment"),
                              Icon(
                                Icons.arrow_downward,
                                size: 16,
                              )
                            ],
                          ))
                      :
                      // ignore: dead_code
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isCommentOpened = false;
                            });
                          },
                          child: Row(
                            children: [
                              Text("Close comments"),
                              Icon(
                                Icons.arrow_upward,
                                size: 16,
                              )
                            ],
                          )),
                  // ignore: dead_code
                  isCommentOpened
                      // ignore: dead_code
                      ? Comments(
                          comments: allComments,
                        )
                      : SizedBox(
                          height: 1,
                        )
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(),
                  width: size.width - 50,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                    ),
                    minLines: 1,
                    maxLines: 13,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (_controller.text.length > 0) {
                        CommentModel newComment = CommentModel(
                            comment: _controller.text,
                            blogId: widget.blog.blogId,
                            userId: ref.read(userProvider).userId);
                        widget.func();

                        ref.read(blogProvider).addComment(newComment);
                        setState(() {
                          allComments?.add(newComment);
                          _controller.text = "";
                        });
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
