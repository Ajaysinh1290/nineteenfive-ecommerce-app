// @dart=2.9


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/splash_screen.dart';
import 'package:nineteenfive_ecommerce_app/utils/app_theme.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget with AppThemeMixin {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(414, 896),
        builder: () {
          return MaterialApp(
            title: 'Nineteenfive',
            debugShowCheckedModeBanner: false,
            theme: appThemeData,
            home: SplashScreen(),
            // home: MyFirebaseAuth.firebaseAuth.currentUser==null?SignUpScreen():LoadData(),
          );
        });
  }
}
