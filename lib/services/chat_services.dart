import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blog_app/models/chat_model.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  List<ChatModel> currentChats = [];

  Future<bool> createChat(String userId) async {
    final String chatId = int.parse(userId) > int.parse(_userService.userId)
        ? userId + "-" + _userService.userId
        : _userService.userId + "-" + userId;
    //_firestore.collection("chats").doc().id;

    final ChatModel chat =
        ChatModel(chatId: chatId, chatUsers: [_userService.userId, userId]);

    try {
      await _firestore.collection("chats").doc(chatId).set(chat.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendMessage(String userId, String messageText) async {
    final String chatId = userId.compareTo(_userService.userId) > 0
        ? userId + "-" + _userService.userId
        : _userService.userId + "-" + userId;

    final MessageModel message = MessageModel(
        senderId: _userService.userId,
        chatId: chatId,
        receiverId: userId,
        message: messageText,
        createdAt: Timestamp.now(),
        seen: false);

    try {
      await _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .add(message.toFirestore());

      _updateChat(_userService.userId, userId, chatId, messageText);

      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<MessageModel>> getMessages(String userId) async* {
    final String chatId = userId.compareTo(_userService.userId) > 0
        ? userId + "-" + _userService.userId
        : _userService.userId + "-" + userId;

    await for (var snapshot in _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("createdAt")
        .snapshots()) {
      print("current data: ${snapshot}");

      List<MessageModel> messages = snapshot.docs.map((doc) {
        return MessageModel.fromFirestore(doc);
      }).toList();

      yield messages;
    }
    /*List<dynamic> allMessages = [];
    final String chatId = userId.compareTo(_userService.userId) > 0
        ? userId + "-" + _userService.userId
        : _userService.userId + "-" + userId;

    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .snapshots()
        .listen((event) {
      print("current data: ${event}");

      List<dynamic> messagesData = event.docs;

    allMessages=  messagesData.map((data) => MessageModel.fromFirestore(data)).toList();


       for (var msg in event.docs) {
        MessageModel _message;
        _message = MessageModel.fromFirestore(msg);
        allMessages.add(_message);
      }
    }, onError: (e) => print(e.toString()));

    yield allMessages;*/
  }

  Future<bool> _updateChat(
      String senderId, String receiverId, String chatId, String message) async {
    ChatModel chatModel = ChatModel(
        chatId: chatId,
        chatUsers: [senderId, receiverId],
        lastMessage: message,
        updatedAt: Timestamp.now());
    try {
      await _firestore
          .collection("chats")
          .doc(chatId)
          .set(chatModel.toFirestore());

      // await _firestore.collection("chats").doc(userId).set(chat.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<ChatModel>> getUserChats() async {
    try {
      final _chatRef = _firestore.collection("chats");
      List<ChatModel> chats = [];

      var sonuc = await _chatRef
          .where("chatUsers", arrayContains: _userService.userId)
          .get();
      //Map<String, dynamic>? _okunanUserBilgileriMap = sonuc.data();

      if (sonuc != null) {
        for (var chat in sonuc.docs) {
          chats.add(ChatModel.fromFirestore(chat));
        }

        currentChats.addAll(chats);
      }

      return chats;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> deleteChat(String chatId) async {
    try {
      final _chatRef = _firestore.collection("chats");
      _chatRef.doc(chatId).delete();

      Future<QuerySnapshot> books =
          _chatRef.doc(chatId).collection("messages").get();
      books.then((value) {
        value.docs.forEach((element) {
          _chatRef
              .doc(chatId)
              .collection("messages")
              .doc(element.id)
              .delete()
              .then((value) => print("success"));
        });
      });

      // _chatRef.delete(chatId).collection("messages").delete();
      currentChats.remove((element) => element.chatId == chatId);

      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }
}

final chatProvider =
    ChangeNotifierProvider<ChatService>((ref) => ChatService());
