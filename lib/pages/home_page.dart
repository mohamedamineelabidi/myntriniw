import 'package:flutter/material.dart';
import 'package:ntrriniw_v0/components/my_app_bar.dart';
import 'package:ntrriniw_v0/components/my_nav_bar.dart';
import 'package:ntrriniw_v0/components/my_post.dart';
import 'package:ntrriniw_v0/components/my_story.dart';

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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return MyStory(
                    imageUrl:
                        'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    username: 'User $index',
                  );
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return MyPost(
                  postImageUrl:
                      "https://i.pinimg.com/736x/b1/57/32/b1573252592009209d45a186360dea8c.jpg",
                  postTime: "2 hours ago",
                  text:
                      "Messi is here what are you going to do ? Messi is here what are you going to do ? Messi is here what are you going to do ? Messi is here what are you going to do ? v Messi is here what are you going to do ? Messi is here what are you going to do ? Messi is here what are you going to do ? Messi is here what are you going to do ? Messi is here what are you going to do ? v Messi is here what are you going to do ? Messi is here what are you going to do ? Messi is here what are you going to do ? Messi is here what are you going to do ? Messi is here what are you going to do ? v Messi is here what are you going to do ?",
                  userImageUrl:
                      'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                  username: 'User $index',
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
