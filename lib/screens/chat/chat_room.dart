import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'message.dart';
import 'message_dao.dart';

class ChatRoom extends StatefulWidget {
  final String user2Id;
  final String user2Name;
  String defaultProfileUrl =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';
  final String profileUrl;

  ChatRoom(
      {Key? key,
      required this.user2Id,
      required this.user2Name,
      required this.profileUrl})
      : super(key: key);

  ////////////////////////////////////////
  // final chatRoomId = "";

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  late var messageDao;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  Future<void> _setChatRoomId() async {
    messageDao = MessageDao(user1: user.uid, user2: widget.user2Id);
  }

  bool _canSendMessage() {
    return _messageController.text.isNotEmpty;
  }

  void _sendMessage() {
    if (_canSendMessage()) {
      var currTime = DateTime.now().toUtc().toString();
      final message = Message(
          message: _messageController.text, senderId: user.uid, time: currTime);
      messageDao.saveMessage(message);
      _messageController.clear();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _setChatRoomId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar with back button, profile picture, and name, and call button
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profileUrl),
            ),
            const SizedBox(width: 10),
            // prevent over flow text if name is too long
            Text(
              widget.user2Name.substring(0, min(widget.user2Name.length, 12)),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),

      // body with messages
      body: Column(children: [_getMessageList()]),

      // type message and send button
      bottomSheet: BottomAppBar(
        child: SizedBox(
          height: 50,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {},
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 10),
                      const Icon(Icons.insert_emoticon),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type a message',
                          ),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            _sendMessage();
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: messageDao.getMessageQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return MessageWidget(
              message: message.message,
              time: message.time,
              isMe: message.senderId == user.uid);
        },
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  const MessageWidget(
      {Key? key, required this.message, required this.time, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final size = msg.length;

    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        // margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        margin: EdgeInsets.fromLTRB(isMe ? 60 : 8, 5, isMe ? 8 : 60, 5),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(15),
          borderRadius: BorderRadius.only(
            topLeft: isMe ? const Radius.circular(15) : Radius.zero,
            topRight: isMe ? Radius.zero : const Radius.circular(15),
            bottomLeft: const Radius.circular(15),
            bottomRight: const Radius.circular(15),
          ),
          color: isMe ? Colors.blue[300] : Colors.grey[300],
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
