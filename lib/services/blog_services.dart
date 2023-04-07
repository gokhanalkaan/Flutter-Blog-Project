import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blog_app/models/blog_model.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import '../models/user_model.dart';

class BlogService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // DocumentSnapshot? _lastCategoryBlogDoc;
  // bool _hasMoreCategoryBlog = true;
  final int _pageSize = 10;

  List<String> currentUserLikedPost = [];

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> addBlog(
    String? creatorId,
    String blogTitle,
    String blogQuote,
    String blogImage,
    String category,
  ) async {
    final blog = BlogModel(
      creatorId: creatorId,
      blogTitle: blogTitle,
      blogQuote: blogQuote,
      blogImage: blogImage,
      blogId: _firestore.collection("blogs").doc().id,
      category: category,
    );
    try {
      await _firestore
          .collection("blogs")
          .doc(blog.blogId)
          .set(blog.toFirestore());

      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<List<BlogModel>> getUserBlog(creatorId) async {
    try {
      final _blogRef = _firestore.collection("blogs");
      List<BlogModel> blogs = [];

      var sonuc = await _blogRef.where("creatorId", isEqualTo: creatorId).get();

      for (var user in sonuc.docs) {
        blogs.add(BlogModel.fromFirestore(user));
      }

      return blogs;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<List<BlogModel>> getCategoryBlogs(String category) async {
    //if (_hasMoreCategoryBlog == false) return Future.error("No more page");

    try {
      final _blogRef = _firestore.collection("blogs");
      List<BlogModel> blogs = [];
      //var  categoryRef = await _blogRef.where("category", isEqualTo: category);
      //var  categoryRef = await _blogRef.where("category", isEqualTo: category);

      var sonuc = category == "All"
          ? await _blogRef
              .orderBy("createdAt")
              // .startAfter([_lastCategoryBlogDoc]!)
              .limit(_pageSize)
              .get()
          : await _blogRef
              .where("category", isEqualTo: category)
              .orderBy("likeCount")
              // .startAfter([_lastCategoryBlogDoc]!)
              .limit(_pageSize)
              .get();

      /* if (sonuc.size < 10) {
        _hasMoreCategoryBlog = false;
      }

      _lastCategoryBlogDoc = sonuc.docs[sonuc.size - 1];*/

      for (var user in sonuc.docs) {
        blogs.add(BlogModel.fromFirestore(user));
      }

      debugPrint(blogs.length.toString());

      return blogs;
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return Future.error(e);
    }
  }

  Future<List<BlogModel>> getUserLikedBlog(String userId) async {
    try {
      final _blogRef = _firestore.collection("blogs");
      List<BlogModel> likedBlogs = [];

      var sonuc =
          await _blogRef.where("likedUsers", arrayContains: userId).get();

      for (var user in sonuc.docs) {
        likedBlogs.add(BlogModel.fromFirestore(user));
      }

      debugPrint("liked blogs" + likedBlogs.first.toString());

      return likedBlogs;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<List<BlogModel>> getTimeline() async {
    UserModel _usermodel = UserModel();
    try {
      final _userRef = _firestore.collection("users");
      final _blogRef = _firestore.collection("blogs");

      List<BlogModel> _blogs = [];
      List<String> followedUsers = [];

      var userResult = await _userRef
          .where(
            "userId",
            isEqualTo: _firebaseAuth.currentUser?.uid,
          )
          .get();

      for (var user in userResult.docs) {
        UserModel usr;
        usr = UserModel.fromFirestore(user);
        currentUserLikedPost.addAll(usr.likedBlogs!);
        followedUsers.addAll(usr.followedUsers!);
        _usermodel.followedUsers?.addAll(usr.followedUsers!);
      }

      debugPrint(followedUsers.first.toString());

      var sonuc =
          await _blogRef.where("creatorId", whereIn: followedUsers).get();

      for (var blg in sonuc.docs) {
        debugPrint(blg.toString());
        _blogs.add(BlogModel.fromFirestore(blg));
      }

      //    _setCurrentUserLikedPosts(_blogs);

      debugPrint("blog:" + _blogs.length.toString());

      notifyListeners();

      return _blogs;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

/*  void _setCurrentUserLikedPosts(List<BlogModel> timelineBlogs) {

    currentUserLikedPost.add(timelineBlogs.map((e) => e.likedUsers.contains(_firebaseAuth.currentUser?.uid)?e.blogId:null)
        );
    
  }*/

  Future<bool> likePost(String blogId) async {
    try {
      final _blogRef = _firestore.collection("blogs");
      final _userRef = _firestore.collection("users");
      await _userRef.doc(_firebaseAuth.currentUser?.uid).update({
        "likedBlogs": FieldValue.arrayUnion([blogId])
      });

      var sonuc = await _blogRef.doc(blogId).update({
        "likedUsers": FieldValue.arrayUnion([_firebaseAuth.currentUser?.uid]),
        "likeCount": FieldValue.increment(1)
      });

      currentUserLikedPost.add(blogId);
      notifyListeners();
      debugPrint(currentUserLikedPost.length.toString());

      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> removeLike(String blogId) async {
    try {
      final _blogRef = _firestore.collection("blogs");

      final _userRef = _firestore.collection("users");
      await _userRef.doc(_firebaseAuth.currentUser?.uid).update({
        "likedBlogs": FieldValue.arrayRemove([blogId]),
      });

      await _blogRef.doc(blogId).update({
        "likedUsers": FieldValue.arrayRemove([_firebaseAuth.currentUser?.uid]),
        "likeCount": FieldValue.increment(-1)
      });

      currentUserLikedPost.remove(
          currentUserLikedPost.firstWhere((element) => element == blogId));
      notifyListeners();
      debugPrint(currentUserLikedPost.length.toString());

      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> addComment(CommentModel comment) async {
    try {
      final _blogRef = _firestore.collection("blogs");

      await _blogRef.doc(comment.blogId).update({
        "comments": FieldValue.arrayUnion([comment.toFirestore()]),
      });

      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }
}

final blogProvider =
    ChangeNotifierProvider<BlogService>((ref) => BlogService());

final authProvider = StreamProvider<User?>((ref) {
  return ref.watch(userProvider).user;
});


///////////////////////



/*final userFollowedProvider =
    ChangeNotifierProvider<userFollowedNotifier>((ref) {

      List<String> followed=[];

    

   followed= ref.watch(blogProvider).followedUsers;
  return ();
});*/
