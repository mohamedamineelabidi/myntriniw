import 'package:flutter/material.dart';
import 'package:ntrriniw_v0/components/my_app_bar.dart';
import 'package:ntrriniw_v0/components/my_button.dart';
import 'package:ntrriniw_v0/components/my_nav_bar.dart';
import 'package:ntrriniw_v0/pages/home_page.dart';
import 'package:ntrriniw_v0/services/auth/auth_gate.dart';
import 'package:ntrriniw_v0/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        appBar: const MyAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 300),
                MyButton(onTap: signOut, text: "Sign Out"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const MyNavBar(selectedIndex: 4));
  }
}
