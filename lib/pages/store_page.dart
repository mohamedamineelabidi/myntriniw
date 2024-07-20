import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Workshops",
              style: GoogleFonts.openSans(
                  fontSize: 25, fontWeight: FontWeight.w800),
            )
          ],
        ),
        bottomNavigationBar: const MyNavBar(selectedIndex: 3));
  }
}
