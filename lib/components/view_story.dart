import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ViewStory extends StatefulWidget {
  final String storyImageUrl;
  final Timestamp storyTime;
  final String userImageUrl;
  final String username;
  final String backgroundColor;
  final Duration displayDuration;

  const ViewStory({
    super.key,
    required this.storyImageUrl,
    required this.storyTime,
    required this.userImageUrl,
    required this.username,
    required this.backgroundColor,
    this.displayDuration = const Duration(seconds: 1),
  });

  @override
  // ignore: library_private_types_in_public_api
  _ViewStoryState createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  late Timer _timer;
  bool _isPaused = false;
  bool _isRowVisible = true;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.displayDuration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds <= 0) {
        _closeStory();
      } else if (!_isPaused) {
        setState(() {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        });
      }
    });
  }

  void _pauseTimer(_) {
    setState(() {
      _isPaused = true;
      _isRowVisible = false;
    });
  }

  void _resumeTimer(_) {
    setState(() {
      _isPaused = false;
      _isRowVisible = true;
    });
  }

  void _resumeTimer2() {
    setState(() {
      _isPaused = false;
      _isRowVisible = true;
    });
  }

  void _closeStory() {
    _timer.cancel();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String colorValueString =
        widget.backgroundColor.replaceAll("Color(", "").replaceAll(")", "");
    int colorValue = int.parse(colorValueString);
    Color backColor = Color(colorValue);
    return Scaffold(
      backgroundColor: backColor,
      body: SafeArea(
        child: GestureDetector(
          onTapDown: _pauseTimer,
          onTapUp: _resumeTimer,
          onTapCancel: _resumeTimer2,
          child: Stack(
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: widget.storyImageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
              if (_isRowVisible)
                Positioned(
                  top: 6.0,
                  left: 6.0,
                  right: 0.0,
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
                                  ? CachedNetworkImageProvider(
                                      widget.userImageUrl)
                                  : const AssetImage("images/user.jpeg")
                                      as ImageProvider,
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
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            _getTimeAgo(widget.storyTime),
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
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
