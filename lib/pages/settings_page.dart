import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ntrriniw_v0/components/my_app_bar.dart';
import 'package:ntrriniw_v0/components/my_button.dart';
import 'package:ntrriniw_v0/components/my_nav_bar.dart';
import 'package:ntrriniw_v0/pages/home_page.dart';
import 'package:ntrriniw_v0/services/auth/auth_gate.dart';
import 'package:ntrriniw_v0/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userDocFuture;

  @override
  void initState() {
    super.initState();
    _userDocFuture = _getUserDoc();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserDoc() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthGate(page: HomePage()),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userDocFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading user data"));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

          final userData = snapshot.data!.data()!;
          final profileImg = userData['profileImg'];
          final username = userData['username'];
          final email = userData['email'];

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: CachedNetworkImageProvider(profileImg),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),
                  MyButton(onTap: signOut, text: "Sign Out"),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const MyNavBar(selectedIndex: 4),
    );
  }
}
