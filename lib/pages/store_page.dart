import 'package:flutter/material.dart';
import 'package:ntrriniw_v0/components/my_app_bar.dart';
import 'package:ntrriniw_v0/components/my_nav_bar.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Center(
          child: Text(
            "The store page ",
            style: TextStyle(fontSize: 24),
          ),
        ),
        bottomNavigationBar: MyNavBar(selectedIndex: 3));
  }
}
