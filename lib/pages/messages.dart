import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog_app/components/message.dart';
import 'package:flutter_blog_app/models/chat_model.dart';
import 'package:flutter_blog_app/services/chat_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Messages extends ConsumerStatefulWidget {
  final String userId;
  final String? chatId;
  const Messages({Key? key, required this.userId, this.chatId})
      : super(key: key);

  @override
  ConsumerState<Messages> createState() => _MessagesState();
}

class _MessagesState extends ConsumerState<Messages> {
  TextEditingController _messageController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Messages")),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: StreamBuilder<List<MessageModel>>(
                  stream: ref.watch(chatProvider).getMessages(widget.userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<MessageModel>? messages = snapshot.data!;

                      if (messages != null) {
                        return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: ((context, index) {
                              MessageModel message = messages[index];

                              return MessageBubble(message);
                            }));
                      } else {
                        return Center(
                          child: Text("No message yet"),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Text("Start a conversation"),
                      );
                    }
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(),
                  width: size.width - 70,
                  child: TextField(
                    scrollController: _scrollController,
                    controller: _messageController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Write a message...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14))),
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(76, 175, 80, 1)),
                    child: IconButton(
                        onPressed: () {
                          ref.read(chatProvider).sendMessage(
                                widget.userId,
                                _messageController.text,
                              );
                          _messageController.text = '';
                        },
                        icon: Icon(Icons.send)))
              ],
            ),
          )
        ],
      )),
    );
  }
}
