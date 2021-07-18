import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/load_data.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/main_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/welcome_screen.dart';
import 'package:nineteenfive_ecommerce_app/widgets/route/CustomPageRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("in logo");
    // pushNextScreen();
  }

  pushNextScreen(BuildContext context, bool isFirstTime) async {
    await Future.delayed(Duration(milliseconds: 100));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => isFirstTime
                ? WelcomeScreen()
                : MyFirebaseAuth.firebaseAuth.currentUser == null
                    ? SignUpScreen()
                    : LoadData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot snapshot) {
            late SharedPreferences preferences;
            bool? firstTime;
            if (snapshot.hasData) {
              preferences = snapshot.data;
              firstTime = preferences.getBool("first_time");

              if (firstTime != null && !firstTime) {
                pushNextScreen(context, false);
              } else {
                pushNextScreen(context, true);
              }
            }
            return Image.asset(
              'assets/logo/nineteenfive_logo.png',
              width: ScreenUtil().setWidth(250),
              fit: BoxFit.cover,
            );
          },
        )),
      ),
    );
  }
}
