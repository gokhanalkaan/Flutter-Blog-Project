import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blog_app/services/blog_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import '../models/user_model.dart';

class UserService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> followedUsers = [];
  List<String> followers = [];
  UserModel? currentUser;

  Stream<User?> get user => _auth.userChanges();

  String get userId => _auth.currentUser!.uid;

  Future<bool> addUser(UserModel user) async {
    try {
      await _firestore
          .collection("users")
          .doc(user.userId)
          .set(user.toFirestore());

      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> checkUsername(String username) async {
    try {
      var val = await _firestore
          .collection("users")
          .where("username", isEqualTo: username)
          .get();

      if (val.size > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getUser(String username) async {
    try {
      final _userRef = _firestore.collection("users");
      UserModel? _foundedUser;

      var sonuc = await _userRef.where("username", isEqualTo: username).get();
      print(sonuc);

      if (sonuc == null) {
        return null;
      }

      for (var user in sonuc.docs) {
        _foundedUser = UserModel.fromFirestore(user);
      }

      return _foundedUser;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<UserModel> getUserWithId(String id) async {
    try {
      final _userRef = _firestore.collection("users");
      UserModel? _foundedUser;

      var sonuc = await _userRef.where("userId", isEqualTo: id).get();

      for (var user in sonuc.docs) {
        _foundedUser = UserModel.fromFirestore(user);
      }
      print("founded user wirth id:" + _foundedUser!.userId!);

      return _foundedUser;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> updateProfilePhoto(String userId, String downloadUrl) async {
    try {
      final _userRef = _firestore.collection("users").doc(userId);
      UserModel? _foundedUser;

      var sonuc = await _userRef.update({"profilePhoto": downloadUrl});
      currentUser!.profilePhoto = downloadUrl;
      // getLoggedInUser();

      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<UserModel> getLoggedInUser() async {
    try {
      final _userRef = _firestore.collection("users");
      UserModel? _foundedUser;

      var sonuc = await _userRef
          .where("userId", isEqualTo: _auth.currentUser?.uid)
          .get();
      print(sonuc);

      

      for (var user in sonuc.docs) {
        _foundedUser = UserModel.fromFirestore(user);
      }
      currentUser = _foundedUser;

      followedUsers.addAll(_foundedUser!.followedUsers!);

      if (_foundedUser.followers != null)
        followers.addAll(_foundedUser.followers!);

      return _foundedUser;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> followUser(String userId) async {
    try {
      final _userRef = _firestore.collection("users");

      var sonuc = await _userRef.doc('${_auth.currentUser?.uid}').update({
        "followedUsers": FieldValue.arrayUnion([userId])
      });

      await _userRef.doc(userId).update({
        "followers": FieldValue.arrayUnion([_auth.currentUser?.uid])
      });

      followedUsers.add(userId);
      notifyListeners();

      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> unfollowUser(String userId) async {
    try {
      final _userRef = _firestore.collection("users");

      var sonuc = await _userRef.doc('${_auth.currentUser?.uid}').update({
        "followedUsers": FieldValue.arrayRemove([userId])
      });

      await _userRef.doc(userId).update({
        "followers": FieldValue.arrayRemove([_auth.currentUser?.uid])
      });

      followedUsers
          .remove(followedUsers.firstWhere((element) => element == userId));
      notifyListeners();

      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  void logOut() async {
    BlogService _blogService = BlogService();
    followedUsers = [];
    followers = [];
    currentUser = null;

    _blogService.currentUserLikedPost = [];

    await _auth.signOut();

    print(_blogService.currentUserLikedPost);
  }
}

final userProvider =
    ChangeNotifierProvider<UserService>((ref) => UserService());



final authProvider = StreamProvider<User?>((ref) {
  return ref.watch(userProvider).user;
});

final currentuserIdProvider = StateProvider<String?>((ref) {
  return ref.watch(userProvider).userId;
});

final currentUserProvider = StateProvider<UserModel>((ref) {
  return ref.watch(userProvider).currentUser!;
});

