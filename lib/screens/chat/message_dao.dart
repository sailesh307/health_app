import 'package:cloud_firestore/cloud_firestore.dart' as store;
import 'package:firebase_database/firebase_database.dart';
import 'package:health_app/screens/chat/message.dart';

class MessageDao {
  late DatabaseReference _messageRef;
  final String user1;
  final String user2;

  MessageDao({required this.user1, required this.user2}) {
    var users = [user1, user2];
    users.sort();

    String chatRoomId = users.join('-');

    // create gateway of two chats
    createGateWay();

    _messageRef =
        FirebaseDatabase.instance.ref('chats').child(chatRoomId).child('chat');
  }

  Future<void> createGateWay() async {
    // make two way terminal if not present
    store.DocumentSnapshot snap1 = await store.FirebaseFirestore.instance
        .collection('users')
        .doc(user1)
        .get();
    store.DocumentSnapshot snap2 = await store.FirebaseFirestore.instance
        .collection('users')
        .doc(user2)
        .get();

    var user1Info = snap1.data() as Map<String, dynamic>;
    var user2Info = snap2.data() as Map<String, dynamic>;

    var user1Data = {
      'uid': user1,
      'name': user1Info['name'],
      'photo': user1Info['profilePhoto']
    };
    var user2Data = {
      'uid': user2,
      'name': user2Info['name'],
      'photo': user2Info['profilePhoto']
    };
    print(user1Data);
    print(user2Data);
    FirebaseDatabase.instance
        .ref('users')
        .child(user1)
        .child(user2)
        .set(user2Data);
    FirebaseDatabase.instance
        .ref('users')
        .child(user2)
        .child(user1)
        .set(user1Data);
  }

  void saveMessage(Message message) {
    print(message.toJson());
    _messageRef.push().set(message.toJson());
  }

  Query getMessageQuery() {
    return _messageRef;
  }
}
