import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 26),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.chat_outlined, size: 26),
          onPressed: () {},
        )
      ],
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.white,
      title: Text(
        "Ntriniw",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
