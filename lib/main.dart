import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ntrriniw_v0/firebase_options.dart';
import 'package:ntrriniw_v0/helpers/shared_prefs_helper.dart';
import 'package:ntrriniw_v0/pages/get_statred.dart';
import 'package:ntrriniw_v0/pages/home_page.dart';
import 'package:ntrriniw_v0/services/auth/auth_gate.dart';
import 'package:ntrriniw_v0/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  bool hasSeen = await SharedPrefsHelper.hasSeenGetStarted();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: MyApp(hasSeen: hasSeen),
  ));
}

class MyApp extends StatefulWidget {
  final bool hasSeen;
  const MyApp({super.key, this.hasSeen = false});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget.hasSeen
          ? const AuthGate(page: HomePage())
          : const GetStarted(),
    );
  }
}
