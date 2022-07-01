import 'package:firebase_database/firebase_database.dart';

class ChatDao {
  late DatabaseReference _chatRef;
  final String yourId;
  ChatDao(this.yourId) {
    _chatRef =
        FirebaseDatabase.instance.ref('users').child(yourId);
  }

  Query getChatQuery() {
    return _chatRef;
  }
}
