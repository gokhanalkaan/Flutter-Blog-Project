import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? username;
  String? email;
  String? profilePhoto;
  List<String>? followedUsers;
  List<String>? followers;
  List<String>? likedBlogs;
  Timestamp? createdAt;

  UserModel(
      {this.userId,
      this.username,
      this.email,
      this.profilePhoto,
      this.followedUsers,
      this.followers,
      this.likedBlogs,
      this.createdAt});

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return UserModel(
        userId: data?['userId'],
        username: data?['username'],
        email: data?['email'],
        profilePhoto: data?['profilePhoto'],
        followedUsers: data?['followedUsers'] is Iterable
            ? List.from(data?['followedUsers'])
            : null,
        followers: data?['followers'] is Iterable
            ? List.from(data?['followers'])
            : null,
        likedBlogs: data?['likedBlogs'] is Iterable
            ? List.from(data?['likedBlogs'])
            : null,
        createdAt: data?['createdAt']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) "userId": userId,
      if (username != null) "username": username,
      if (email != null) "email": email,
      "profilePhoto": profilePhoto ?? "",
      "followedUsers": followedUsers ?? [],
      "followers": followers ?? [],
      "likedBlogs": likedBlogs ?? [],
      "createdAt": FieldValue.serverTimestamp()
    };
  }
}
