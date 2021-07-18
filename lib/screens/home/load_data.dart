import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/models/category.dart';
import 'package:nineteenfive_ecommerce_app/models/poster.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/models/user_data.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/main_screen.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';

import '../../utils/data/static_data.dart';

class LoadData extends StatefulWidget {
  @override
  _LoadDataState createState() => _LoadDataState();
}

class _LoadDataState extends State<LoadData> {
  double angle = 0;
  late Timer timer;
  bool pushed = false;

  pushNextScreen() async {


    if(!pushed) {
      pushed = true;
      timer.cancel();
      await Future.delayed(Duration(milliseconds: 0));
      print('Pushing');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }

  }

  Widget showLoading(AsyncSnapshot snapshot) {
    late Widget child;
    if (snapshot.hasError) {
      child = Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(28.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.error,
                  color: ColorPalette.grey,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Something went wrong..!',
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              snapshot.error.toString(),
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      );
    } else {
      double length = 130;
      double padding = 3;
      child = Stack(
        children: [
          Container(
            width: ScreenUtil().setWidth(length),
            height: ScreenUtil().setWidth(length),
            padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
            child: Image.asset(
              'assets/logo/nineteenfive_logo.png',
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setHeight(80),
              alignment: Alignment.center,
            ),
          ),
          RotationTransition(
              turns: AlwaysStoppedAnimation(angle / 360),
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: ScreenUtil().setWidth(length),
                height: ScreenUtil().setWidth(length),
                child: Container(
                  padding: EdgeInsets.all(padding),
                  child: Image.asset(
                    'assets/icons/half_colored_circle_thick.png',
                    width: ScreenUtil().setWidth(length),
                    height: ScreenUtil().setWidth(length),
                  ),
                ),
              )),
        ],
      );
    }
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(child: child),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if(this.mounted) {
        setState(() {
          angle += 1;
        });
      }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer.isActive) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(MyFirebaseAuth.firebaseAuth.currentUser!.uid)
            .get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            StaticData.userData = UserData.fromJson(snapshot.data.data());
          }
          return !snapshot.hasData
              ? showLoading(snapshot)
              : FutureBuilder(
                  future:
                      FirebaseFirestore.instance.collection('products').get(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data.docs;
                      StaticData.products = [];
                      data.forEach((element) {
                        StaticData.products
                            .add(Product.fromJson(element.data()));
                      });
                    }
                    return !snapshot.hasData
                        ? showLoading(snapshot)
                        : FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('categories')
                                .get(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                StaticData.categoriesList = [];
                                List data = snapshot.data.docs;
                                data.forEach((element) {
                                  StaticData.categoriesList
                                      .add(Category.fromJson(element.data()));
                                });
                              }
                              return !snapshot.hasData
                                  ? showLoading(snapshot)
                                  : FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('posters')
                                          .get(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          StaticData.posters = [];
                                          List data = snapshot.data.docs;
                                          data.forEach((element) {
                                            StaticData.posters.add(
                                                Poster.fromJson(
                                                    element.data()));
                                          });
                                          pushNextScreen();
                                        }
                                        return showLoading(snapshot);
                                      },
                                    );
                            },
                          );
                  },
                );
        });
  }
}
