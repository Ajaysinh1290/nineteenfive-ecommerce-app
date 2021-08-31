
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/firebase/dynamic_link/dynamic_link_service.dart';
import 'package:nineteenfive_ecommerce_app/firebase/notification/local_notification_service.dart';
import 'package:nineteenfive_ecommerce_app/firebase/notification/notification_service.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/home_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/drawer_screen.dart';

import '../../utils/data/static_data.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Widget child;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  DynamicLinkService dynamicLinkService = DynamicLinkService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    child = HomeScreen(onDrawerClick: onDrawerClick);
    dynamicLinkService.handleDynamicLinks(context);
    NotificationService.startService(context);

    // fetchUserData();
  }

  fetchUserData() async {
    StaticData.userData = await FirebaseDatabase.getUserData(
        MyFirebaseAuth.firebaseAuth.currentUser!.uid);
  }

  onDrawerClick() {
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      setState(() {
        xOffset = ScreenUtil().setWidth(250);
        yOffset = ScreenUtil().setHeight(200);
        scaleFactor = 0.6;
        isDrawerOpen = true;
      });
    });
  }

  onDrawerChanged(Widget widget) {
    setState(() {
      xOffset = ScreenUtil().setWidth(400);
      yOffset = ScreenUtil().setHeight(200);
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      setState(() {
        child = widget;
        xOffset = ScreenUtil().setWidth(0);
        yOffset = ScreenUtil().setHeight(0);
        scaleFactor = 1;
        isDrawerOpen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(414, 896),
        orientation: Orientation.portrait);
    return Scaffold(
        body: Stack(
      children: [
        DrawerScreen(
          onChanged: (widget) {
            // setState(() {
            //   child =widget;
            // });
            onDrawerChanged(widget);
          },
          onDrawerClick: onDrawerClick,
        ),
        GestureDetector(
            onTap: isDrawerOpen
                ? () {
                    setState(() {
                      xOffset = 0;
                      yOffset = 0;
                      scaleFactor = 1;
                      isDrawerOpen = false;
                    });
                  }
                : null,
            onHorizontalDragUpdate: (details) {
              if (details.primaryDelta! > 0) {
                setState(() {
                  onDrawerClick();
                });
              }
            },
            child: AnimatedContainer(
                transform: Matrix4.translationValues(xOffset, yOffset, 0)
                  ..scale(scaleFactor),
                curve: isDrawerOpen ? Curves.easeOutBack : Curves.easeOutExpo,
                duration: Duration(milliseconds: 1000),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().radius(35)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          spreadRadius: 1,
                          blurRadius: 40)
                    ]),
                width: MediaQuery.of(context).size.width,
                child: AbsorbPointer(
                    absorbing: isDrawerOpen,
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().radius(isDrawerOpen?35:0)),
                        child: child))))
      ],
    ));
  }
}
