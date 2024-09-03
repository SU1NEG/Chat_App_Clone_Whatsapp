import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    final userDoc = _db.collection('users').doc(user.uid);

    final userData = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
    };

    await userDoc.set(userData, SetOptions(merge: true));
  }

  Future<void> updateUser(User user) async {
    final userDoc = _db.collection('users').doc(user.uid);

    final userData = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
    };

    await userDoc.update(userData);
  }

  Future<Map<String, dynamic>> getUser(String uid) async {
    final userDoc = await _db.collection('users').doc(uid).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  Future<void> addMessage(String message, User user) async {
    final messageDoc = _db.collection('messages').doc();
    final messageData = {
      'message': message,
      'uid': user.uid,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await messageDoc.set(messageData);
  }

  Stream<List<Map<String, dynamic>>> getMessages() {
    return _db
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  Stream<List<Map<String, dynamic>>> getUserChats(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('chats')
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  // Function to create a new chat for a user
  Future<void> createChat(String chatWithUid, String initialMessage) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final chatDoc = _db
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(chatWithUid);

      await chatDoc.set({
        'chatWith': chatWithUid,
        'lastMessage': initialMessage,
        'lastMessageTime': Timestamp.now(),
      });

      await chatDoc.collection('messages').add({
        'senderUid': user.uid,
        'messageText': initialMessage,
        'timestamp': Timestamp.now(),
      });
    }
  }

  // Function to update the last message in a chat
  Future<void> updateLastMessage(String chatId, String lastMessage) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userChatsCollection =
        _db.collection('users').doc(userId).collection('chats');

    final chatDoc = userChatsCollection.doc(chatId);

    final messageData = {
      'lastMessage': lastMessage,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': FieldValue.increment(1),
    };

    // Update the last message and timestamp in the chat
    await chatDoc.update(messageData);
  }

  Future<List<Map<String, dynamic>>> getUserFriends(String uid) async {
    final userDoc =
        await _db.collection('users').doc(uid).collection('friends').get();
    return userDoc.docs.map((doc) => doc.data()).toList();
  }

  // Add a friend to the user's friends list
  Future<void> addFriend(
      String friendUid, String friendName, String friendEmail) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final friendData = {
        'uid': friendUid,
        'displayName': friendName,
        'email': friendEmail,
      };

      await _db
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .doc(friendUid)
          .set(friendData);
    }
  }
}
