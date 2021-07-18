import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/models/user_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/widgets/dialog/my_dialog.dart';

class MyFirebaseAuth {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  BuildContext context;

  MyFirebaseAuth(this.context);

  Future<bool> signUp(String email, String password, String name) async {
    try {

      MyDialog.showLoading(context);
      UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;

      await user!.updateProfile(displayName: name);
      await FirebaseDatabase.storeUserData(
          UserData(userId: user.uid, email: email, userName: name));
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      await MyDialog.showMyDialog(context, e.message);
    } catch (e) {
      Navigator.pop(context);
      await MyDialog.showMyDialog(context, 'Error');
      print(e);
    }
    return false;
  }

  Future<bool> updateData(
      String name, String phoneNumber, String photoUrl) async {
    try {
      MyDialog.showLoading(context);

      await firebaseAuth.currentUser!.updateDisplayName(name);

      StaticData.userData.userName = name;
      StaticData.userData.mobileNumber = phoneNumber;

      if (photoUrl.isNotEmpty) {
        await firebaseAuth.currentUser!.updatePhotoURL(photoUrl);
        StaticData.userData.userProfilePic = photoUrl;
      }
      await FirebaseDatabase.storeUserData(StaticData.userData);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      MyDialog.showMyDialog(context, 'Updated');
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e.code);
      await MyDialog.showMyDialog(context, e.message);
    } catch (e) {
      Navigator.pop(context);
      await MyDialog.showMyDialog(context, 'Error');
      print(e);
    }
    return false;
  }

  Future<bool> signIn(String email, String password) async {


    try {
      MyDialog.showLoading(context);
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        MyDialog.showMyDialog(context, 'Email is not found!');
      } else if (e.code == 'wrong-password') {
        MyDialog.showMyDialog(context, "Wrong password!");
      } else {
        MyDialog.showMyDialog(context, e.message);
      }
    } catch (e) {
      Navigator.pop(context);
      await MyDialog.showMyDialog(context, 'Error');
      print(e);
    }
    return false;
  }

  Future<bool> updateEmail(String email, String password) async {
    try {
      MyDialog.showLoading(context);
      print(FirebaseAuth.instance.currentUser);
      AuthCredential credential = EmailAuthProvider.credential(
          email: StaticData.userData.email, password: password);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      StaticData.userData.email = email;
      await FirebaseDatabase.storeUserData(StaticData.userData);
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        MyDialog.showMyDialog(context, 'Email is not found!');
      } else if (e.code == 'wrong-password') {
        MyDialog.showMyDialog(context, "Wrong password!");
      } else {
        MyDialog.showMyDialog(context, e.message);
      }
    } catch (e) {
      Navigator.pop(context);
      await MyDialog.showMyDialog(context, 'Error\n${e.toString()}');
      print(e);
    }
    return false;
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      MyDialog.showLoading(context);
      print(FirebaseAuth.instance.currentUser);
      AuthCredential credential = EmailAuthProvider.credential(
          email: StaticData.userData.email, password: oldPassword);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        MyDialog.showMyDialog(context, 'Email is not found!');
      } else if (e.code == 'wrong-password') {
        MyDialog.showMyDialog(context, "Wrong password!");
      } else {
        MyDialog.showMyDialog(context, e.message);
      }
    } catch (e) {
      Navigator.pop(context);
      await MyDialog.showMyDialog(context, 'Error\n${e.toString()}');
      print(e);
    }
    return false;
  }

  Future<bool> resetPassword(String email) async {
    try {
      MyDialog.showLoading(context);
      await firebaseAuth.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      MyDialog.showMyDialog(context,
          'Password reset link sent to your email address successfully !');
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        MyDialog.showMyDialog(context, 'Email is not found!');
      } else {
        MyDialog.showMyDialog(context, e.message);
      }
    } catch (e) {
      Navigator.pop(context);
      print(e);
    }
    return false;
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        await FirebaseDatabase.storeUserData(UserData(
            userId: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            userName: userCredential.user!.displayName ?? '',
            userProfilePic: userCredential.user!.photoURL,
            mobileNumber: userCredential.user!.phoneNumber));
      }

      // MyDialog.showLoading(context);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
