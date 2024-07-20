import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String username;
  final String userImageUrl;
  final String text;
  final Timestamp timestamp;

  Comment({
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.text,
    required this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      userId: doc['userId'],
      username: doc['username'],
      userImageUrl: doc['userImageUrl'],
      text: doc['text'],
      timestamp: doc['timestamp'],
    );
  }
}
