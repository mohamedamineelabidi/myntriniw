import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ntrriniw_v0/components/my_button.dart';
import 'package:ntrriniw_v0/components/my_text_field.dart';
import 'package:ntrriniw_v0/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();
  final passwdcontroller = TextEditingController();

  Color _textColor = Colors.black;

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
        emailcontroller.text,
        passwdcontroller.text,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

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
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset('images/login.png',
                        width: 100, height: 100),
                    const SizedBox(height: 25),
                    Text(
                      "Welcome back to Ntriniw",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                        controller: emailcontroller,
                        hintText: "Email",
                        obscureText: false),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: passwdcontroller,
                        hintText: "Password",
                        obscureText: true),
                    const SizedBox(height: 25),
                    MyButton(onTap: signIn, text: "Sign In"),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member?",
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          onTapDown: (_) {
                            setState(() {
                              _textColor = const Color(0xFFBEE0C4);
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _textColor = Colors.black;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              _textColor = Colors.black;
                            });
                          },
                          child: Text(
                            "Register now",
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 45),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
