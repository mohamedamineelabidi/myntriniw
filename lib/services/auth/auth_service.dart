import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // _fireStore.collection('users').doc(userCredential.user!.uid).set({
      //   "uid": userCredential.user!.uid,
      //   "email": email,
      // }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailandPassword(
      String email, password, username, image) async {
    try {
      print("}}}}}}}}}}}}}}}] 0");
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('usersProfile/${DateTime.now().toIso8601String()}');
        await storageRef.putFile(image!);
        final downloadURL = await storageRef.getDownloadURL();

        _fireStore.collection('users').doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "username": username,
          "email": email,
          "profileImg": downloadURL,
        });
      } else {
        _fireStore.collection('users').doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "username": username,
          "email": email,
          "profileImg": 'defautIMG',
        });
        print("}}}}}}}}}}}}}}}] 5");
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
