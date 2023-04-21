import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog_app/components/bottom_navbar.dart';
import 'package:flutter_blog_app/components/chat_user.dart';
import 'package:flutter_blog_app/models/chat_model.dart';
import 'package:flutter_blog_app/services/chat_services.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    String currentUserId = ref.read(userProvider).userId;

    var chats = ref.read(chatProvider).currentChats;
    var val = ref.watch(chatProvider).currentChats.every(
          (element) => chats.every((b) => element.chatId == b.chatId),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<List<ChatModel>>(
              future: ref.read(chatProvider).getUserChats(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ChatModel> chats = snapshot.data!;
                  if (chats.length > 0) {
                    return ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: ((context, index) {
                          ChatModel currChat = chats[index];
                          String _otherUserId = currChat.chatUsers!.singleWhere(
                              (element) => element != currentUserId);

                          return ChatUser(
                              chat: currChat,
                              otherUserId: _otherUserId,
                              func: () => {
                                    setState(
                                      () {},
                                    )
                                  });
                        }));
                  } else {
                    return Center(
                      child: Text("No conversation"),
                    );
                  }
                } else {
                  return Center(
                    child: Text("No conversation"),
                  );
                }
              },
            )),
            BottomNavbar(selectedIndex: 4)
          ],
        ),
      ),
    );
  }
}
