import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntrriniw_v0/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  final StatefulWidget page;
  const AuthGate({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return page;
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
