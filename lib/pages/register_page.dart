import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ntrriniw_v0/components/my_button.dart';
import 'package:ntrriniw_v0/components/my_text_field.dart';
import 'package:ntrriniw_v0/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? _image;
  final picker = ImagePicker();
  final usernamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwdcontroller = TextEditingController();
  final confirmPasswdcontroller = TextEditingController();

  Color _textColor = Colors.black;

  void signUp() async {
    if (passwdcontroller.text != confirmPasswdcontroller.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match!")));
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      authService.signUpWithEmailandPassword(emailcontroller.text,
          passwdcontroller.text, usernamecontroller.text, _image);
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

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202528),
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
                    GestureDetector(
                      onTap: () async {
                        await _pickImage();
                      },
                      child: ClipOval(
                        child: Container(
                          width: 130.0,
                          height: 130.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: _image == null
                                  ? const AssetImage("images/user.jpeg")
                                  : FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Let's create an account for you!",
                      style: GoogleFonts.montserrat(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                        controller: usernamecontroller,
                        hintText: "Username",
                        obscureText: false),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: emailcontroller,
                        hintText: "Email",
                        obscureText: false),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: passwdcontroller,
                        hintText: "Password",
                        obscureText: true),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: confirmPasswdcontroller,
                        hintText: "Confirm password",
                        obscureText: true),
                    const SizedBox(height: 25),
                    MyButton(onTap: signUp, text: "Sign Up"),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already a member?",
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
                            "Login now",
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
