import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ntrriniw_v0/components/my_app_bar.dart';
import 'package:ntrriniw_v0/components/my_nav_bar.dart';
import 'package:ntrriniw_v0/components/my_post.dart';
import 'package:ntrriniw_v0/components/my_story.dart';
import 'package:ntrriniw_v0/components/my_new.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      bottomNavigationBar: const MyNavBar(selectedIndex: 0),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 110.0,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("stories")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const NewPage(),
                      ...snapshot.data!.docs
                          .map<Widget>((doc) => _buildStoryListItem(doc)),
                    ],
                  );
                },
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, postSnapshot) {
              if (postSnapshot.hasError) {
                return const SliverToBoxAdapter(
                    child: Text("Error loading posts"));
              }

              if (postSnapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              }

              if (postSnapshot.data!.docs.isEmpty) {
                return const SliverToBoxAdapter(
                    child: Center(child: Text("No posts available")));
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var postData = postSnapshot.data!.docs[index];

                    return MyPost(
                      postImageUrl: postData['image_url'],
                      postTime: _getTimeAgo(postData['timestamp']),
                      text: postData['text'],
                      userImageUrl: postData['profileImg'],
                      username: postData['username'],
                    );
                  },
                  childCount: postSnapshot.data!.docs.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoryListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    return MyStory(
      storyImageUrl: data["image_url"],
      storyTime: data['timestamp'],
      userImageUrl: data['profileImg'],
      username: data['username'],
      backgroundColor: data['backgroundColor'],
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
