import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntrriniw_v0/model/comment.dart';

class MyPost extends StatefulWidget {
  final String postId;
  final String userImageUrl;
  final String username;
  final String postTime;
  final String postImageUrl;
  final String text;

  const MyPost({
    super.key,
    required this.postId,
    required this.userImageUrl,
    required this.username,
    required this.postTime,
    required this.postImageUrl,
    required this.text,
  });

  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  bool _isExpanded = false;
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadLikes();
    _loadComments();
  }

  void _loadLikes() async {
    DocumentSnapshot postSnapshot =
        await _firestore.collection('posts').doc(widget.postId).get();
    if (postSnapshot.exists) {
      List<dynamic> likes = postSnapshot['likes'] ?? [];
      setState(() {
        _likeCount = likes.length;
        _isLiked = likes.contains(_auth.currentUser!.uid);
      });
    }
  }

  void _loadComments() async {
    QuerySnapshot commentSnapshot = await _firestore
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      _comments =
          commentSnapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
      _commentCount = commentSnapshot.docs.length;
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleLike() async {
    DocumentReference postRef =
        _firestore.collection('posts').doc(widget.postId);
    User currentUser = _auth.currentUser!;

    _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);

      if (!snapshot.exists) {
        postRef.set({'likes': []});
      }

      List<dynamic> likes = snapshot.get('likes') ?? [];
      if (likes.contains(currentUser.uid)) {
        likes.remove(currentUser.uid);
        setState(() {
          _isLiked = false;
          _likeCount -= 1;
        });
      } else {
        likes.add(currentUser.uid);
        setState(() {
          _isLiked = true;
          _likeCount += 1;
        });
      }

      transaction.update(postRef, {'likes': likes});
    });
  }

  void _addComment() async {
    String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      User currentUser = _auth.currentUser!;
      DocumentSnapshot<Map<String, dynamic>> userInfo = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(currentUser.uid)
          .get();

      await _firestore
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'userId': currentUser.uid,
        'username': userInfo.data()?['username'],
        'userImageUrl': userInfo.data()?['profileImg'],
        'text': commentText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _commentController.clear();
      setState(() {
        _commentCount += 1;
      });
      _loadComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: widget.userImageUrl != "defaultIMG"
                            ? CachedNetworkImageProvider(widget.userImageUrl)
                            : const AssetImage("images/user.jpeg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.postTime,
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CachedNetworkImage(
            imageUrl: widget.postImageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: _isLiked
                      ? const Icon(Icons.thumb_up_alt)
                      : const Icon(Icons.thumb_up_alt_outlined),
                  onPressed: _toggleLike,
                ),
                Text(
                  '$_likeCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: _toggleExpanded,
                ),
                Text(
                  '$_commentCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.save_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isExpanded
                    ? GestureDetector(
                        onTap: _toggleExpanded,
                        child: Text(
                          widget.text,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      )
                    : GestureDetector(
                        onTap: _toggleExpanded,
                        child: Text(
                          widget.text,
                          style: const TextStyle(fontSize: 14.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                const SizedBox(height: 10),
                _isExpanded
                    ? Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _comments.length,
                            itemBuilder: (context, index) {
                              Comment comment = _comments[index];
                              return ListTile(
                                leading: ClipOval(
                                  child: Image.network(
                                    comment.userImageUrl,
                                    width: 40.0,
                                    height: 40.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(comment.username),
                                subtitle: Text(comment.text),
                                trailing: Text(_getTimeAgo(comment.timestamp)),
                              );
                            },
                          ),
                          TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              labelText: 'Add a comment...',
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Color.fromARGB(255, 58, 163, 70),
                                ),
                                onPressed: _addComment,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(Timestamp timestamp) {
    final DateTime postTime = timestamp.toDate();
    final Duration difference = DateTime.now().difference(postTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
