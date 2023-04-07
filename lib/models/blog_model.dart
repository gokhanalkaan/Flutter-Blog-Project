import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  String? blogId;
  String? creatorId;
  final String? blogImage;
  String? blogTitle;

  String? blogQuote;
  int? likeCount;
  String category;

  List<String>? likedUsers;
  List<CommentModel>? comments;
  Timestamp? createdAt;

  BlogModel({
    this.blogId,
    required this.creatorId,
    required this.blogTitle,
    required this.blogQuote,
    required this.category,
    this.blogImage,
    this.likedUsers,
    this.comments,
    this.createdAt,
    this.likeCount,
  });

  factory BlogModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BlogModel(
      blogId: data?['blogId'],
      creatorId: data?['creatorId'],
      likedUsers: data?['likedUsers'] is Iterable
          ? List.from(data?['likedUsers'])
          : null,
      blogTitle: data?['blogTitle'],
      blogQuote: data?['blogQuote'],
      blogImage: data?['blogImage'],
      createdAt: data?['createdAt'],
      likeCount: data?['likeCount'],
      category: data?['category'],
      comments: data?["comments"] == null
          ? []
          : List<CommentModel>.from(
              data!["comments"].map((x) => CommentModel.fromFirestore(x))),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (blogId != null) "blogId": blogId,
      if (creatorId != null) "creatorId": creatorId,
      "likedUsers": likedUsers ?? [],
      if (creatorId != null) "creatorId": creatorId,
      if (blogTitle != null) "blogTitle": blogTitle,
      if (blogQuote != null) "blogQuote": blogQuote,
      "likeCount": 0,
      if (blogImage != null) "blogImage": blogImage,
      "category": category,
      "comments": comments == null
          ? []
          : List<CommentModel>.from(comments!.map((x) => x.toFirestore())),
      "createdAt": FieldValue.serverTimestamp()
    };
  }
}

class CommentModel {
  String? blogId;
  String? userId;
  String? comment;

  CommentModel({required this.userId, required this.comment, this.blogId});

  factory CommentModel.fromFirestore(
      // DocumentSnapshot<Map<String, dynamic>> snapshot,
      dynamic data) {
    // final data = snapshot.data();
    return CommentModel(
      userId: data?['userId'] == null ? null : data?['userId'],
      comment: data?['comment'] == null ? null : data?['comment'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) "userId": userId,
      if (comment != null) "comment": comment,
    };
  }
}
