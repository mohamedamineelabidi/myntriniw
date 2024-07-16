import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyPost extends StatefulWidget {
  final String userImageUrl;
  final String username;
  final String postTime;
  final String postImageUrl;
  final String text;

  const MyPost({
    super.key,
    required this.userImageUrl,
    required this.username,
    required this.postTime,
    required this.postImageUrl,
    required this.text,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
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
                // const Spacer(),
                // IconButton(
                //   icon: const Icon(Icons.close_outlined),
                //   onPressed: () {},
                // ),
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
                  icon: const Icon(Icons.thumb_up_alt_outlined),
                  onPressed: () {},
                ),
                const Text(
                  '117',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {},
                ),
                const Text(
                  '117',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                // GestureDetector(
                //   onTap: _toggleExpanded,
                //   child: Text(
                //     _isExpanded ? 'Less' : 'More',
                //     style: const TextStyle(color: Colors.grey),
                //   ),
                // ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
