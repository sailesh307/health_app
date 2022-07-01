import 'package:firebase_database/firebase_database.dart';
import 'package:health_app/helperFunction/sharedpref_helper.dart';

class ChatMethods {
  Future addMessage({required String chatRoomId, required String message}) {
    
    // add message to real time database
    return FirebaseDatabase.instance.ref('chats').child(chatRoomId).child('chat').push().set({
      'message': message,
      'timestamp': DateTime.now().toUtc(),
      'sender': SharedPreferenceHelper().getUserId(),
    });
  }
}
