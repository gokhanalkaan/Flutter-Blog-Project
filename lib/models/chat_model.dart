import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String chatId;
  List<String>? chatUsers;
  String? lastMessage;

  Timestamp? updatedAt;

  ChatModel(
      {required this.chatId,
      required this.chatUsers,
      this.lastMessage,
      this.updatedAt});

  factory ChatModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ChatModel(
      chatId: data?['chatId'],
      lastMessage: data?['lastMessage'],
      chatUsers:
          data?['chatUsers'] is Iterable ? List.from(data?['chatUsers']) : null,
      updatedAt: data?['updatedAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (chatId != null) "chatId": chatId,
      "chatUsers": chatUsers ?? [],
      if (lastMessage != null) "lastMessage": lastMessage,
      if (updatedAt != null) "updatedAt": updatedAt,
    };
  }
}

class MessageModel {
  String chatId;
  String senderId;
  String receiverId;
  String message;
  bool? seen;
  Timestamp? createdAt;

  MessageModel(
      {required this.senderId,
      required this.chatId,
      required this.receiverId,
      required this.message,
      this.seen,
      this.createdAt});

  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MessageModel(
      senderId: data?['senderId'],
      chatId: data?['chatId'],
      receiverId: data?['receiverId'],
      message: data?['message'],
      seen: data?['seen'],
      createdAt: data?['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (senderId != null) "senderId": senderId,
      if (chatId != null) "chatId": chatId,
      if (receiverId != null) "receiverId": receiverId,
      if (seen != null) "seen": seen,
      if (message != null) "message": message,
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
