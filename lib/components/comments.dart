import 'package:flutter/material.dart';
import 'package:flutter_blog_app/components/comment.dart';

import 'package:flutter_blog_app/models/blog_model.dart';

class Comments extends StatelessWidget {
  const Comments({
    Key? key,
    required this.comments,
  }) : super(key: key);

  final List<CommentModel>? comments;

  @override
  Widget build(BuildContext context) {
    return comments!.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: comments?.length,
            itemBuilder: ((context, index) {
              CommentModel curr;
              curr = comments![index];
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Comment(
                  comment: curr,
                ),
              );
            }))
        : Center(child: Text("No comments"));
  }
}
