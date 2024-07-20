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

                  // Group stories by user
                  Map<String, List<DocumentSnapshot>> userStoriesMap = {};
                  for (var doc in snapshot.data!.docs) {
                    String userId = doc['userId'];
                    if (userStoriesMap.containsKey(userId)) {
                      userStoriesMap[userId]!.add(doc);
                    } else {
                      userStoriesMap[userId] = [doc];
                    }
                  }

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const NewPage(),
                      ...userStoriesMap.entries.map<Widget>((entry) {
                        return _buildUserStoryListItem(entry.key, entry.value);
                      }).toList(),
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
                      postId: postData.id,
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

  Widget _buildUserStoryListItem(String userId, List<DocumentSnapshot> stories) {
    var data = stories.first.data()! as Map<String, dynamic>;
    return MyStory(
      stories: stories,
      userImageUrl: data['profileImg'],
      username: data['username'],
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
