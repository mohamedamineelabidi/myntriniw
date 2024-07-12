import 'package:flutter/material.dart';
import 'package:ntrriniw_v0/components/my_button.dart';
import 'package:ntrriniw_v0/helpers/shared_prefs_helper.dart';
import 'package:ntrriniw_v0/pages/home_page.dart';
import 'package:ntrriniw_v0/services/auth/auth_gate.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF1F6F9),
              Color(0xFFFFFDFF),
            ],
            stops: [0.1, 0.4],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/start.png"),
                  const SizedBox(height: 40),
                  Text(
                    "Start",
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Your Journey",
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "You will have everything you want to reach",
                    style: GoogleFonts.openSans(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "your personal fitness goals",
                    style: GoogleFonts.openSans(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 60),
                  MyButton(
                      onTap: () async {
                        await SharedPrefsHelper.setSeenGetStarted(true);
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const AuthGate(page: HomePage()),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      text: "Get started"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
