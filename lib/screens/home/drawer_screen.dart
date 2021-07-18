import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/authentication/login_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/contact/help_and_support.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/home_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/product/products.dart';
import 'package:nineteenfive_ecommerce_app/screens/address/your_addresses.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/your_orders.dart';
import 'package:nineteenfive_ecommerce_app/screens/user/your_profile.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';
import 'package:nineteenfive_ecommerce_app/widgets/route/CustomPageRoute.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/data/static_data.dart';

class DrawerScreen extends StatefulWidget {
  final Function(Widget) onChanged;
  final Function onDrawerClick;

  DrawerScreen({required this.onChanged, required this.onDrawerClick});

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int selectedIndex = 0;

  getListTile(IconData iconData, String text, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15)),
      child: Row(
        children: [
          Icon(
            iconData,
            color:
                selectedIndex == index ? ColorPalette.black : Colors.grey[600],
            size: ScreenUtil().setWidth(index == selectedIndex ? 26 : 24),
          ),
          SizedBox(width: ScreenUtil().setWidth(15)),
          Text(text,
              style: GoogleFonts.poppins(
                  color: selectedIndex == index
                      ? ColorPalette.black
                      : Colors.grey[600],
                  fontSize: selectedIndex == index ? 20.sp : 18.sp,
                  letterSpacing: 0.5,
                  fontWeight: selectedIndex == index
                      ? FontWeight.w600
                      : FontWeight.w500))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: ScreenUtil().setHeight(900),
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(0)),
        padding: EdgeInsets.only(
            top: 10 + MediaQuery.of(context).padding.top,
            right: ScreenUtil().setWidth(160),
            left: 10,
            bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xfff6f5f5),
          // gradient: LinearGradient(
          //   colors: [
          //     ColorPalette.blue.withOpacity(0.1),
          //     ColorPalette.blue.withOpacity(0.2)
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight
          // )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                MyFirebaseAuth.firebaseAuth.currentUser != null &&
                        MyFirebaseAuth.firebaseAuth.currentUser!.photoURL !=
                            null
                    ? Container(
                        height: ScreenUtil().setWidth(60),
                        width: ScreenUtil().setWidth(60),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPalette.lightGrey,
                        ),
                        child: ClipOval(
                          child: ImageNetwork(
                            width: ScreenUtil().setWidth(67),
                            height: ScreenUtil().setWidth(67),
                            fit: BoxFit.cover,
                            imageUrl: MyFirebaseAuth
                                    .firebaseAuth.currentUser!.photoURL ??
                                '',
                            errorIcon: CupertinoIcons.person_fill,
                          ),
                        ),
                      )
                    : Container(
                        height: ScreenUtil().setWidth(60),
                        width: ScreenUtil().setWidth(60),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPalette.grey.withOpacity(0.2),
                        ),
                        child: Icon(
                          CupertinoIcons.person_fill,
                          size: ScreenUtil().setWidth(32),
                          color: ColorPalette.darkGrey,
                        ),
                      ),
                SizedBox(
                  width: ScreenUtil().setWidth(15),
                ),
                if (MyFirebaseAuth.firebaseAuth.currentUser != null)
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          MyFirebaseAuth
                                  .firebaseAuth.currentUser!.displayName ??
                              '',
                          style: Theme.of(context).textTheme.headline5,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          MyFirebaseAuth.firebaseAuth.currentUser!.email ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 16.sp,
                              color: ColorPalette.darkGrey),
                        )
                      ],
                    ),
                  )
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    selectedIndex = 0;
                    widget.onChanged.call(HomeScreen(
                      onDrawerClick: () => widget.onDrawerClick.call(),
                    ));
                  },
                  child: getListTile(CupertinoIcons.house, 'Home', 0),
                ),
                GestureDetector(
                    onTap: () {
                      selectedIndex = 1;
                      widget.onChanged.call(YourProfile(
                        onDrawerClick: widget.onDrawerClick,
                      ));
                      // Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => YourProfile())).then((value) {
                      //     setState(() {});
                      //   });
                    },
                    child:
                        getListTile(CupertinoIcons.person, 'Your Profile', 1)),
                GestureDetector(
                    onTap: () {
                      selectedIndex = 2;
                      widget.onChanged.call(YourOrders(
                        onDrawerClick: widget.onDrawerClick,
                      ));
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => YourOrders()));
                    },
                    child: getListTile(Icons.card_travel, 'Your Orders', 2)),
                GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => LikedProducts()));
                      List<Product> products = [];
                      StaticData.userData.likedProducts!
                          .forEach((likedProduct) {
                        StaticData.products.forEach((product) {
                          if (product.productId == likedProduct) {
                            products.add(product);
                          }
                        });
                      });
                      selectedIndex = 3;
                      widget.onChanged.call(Products(
                        onDrawerClick: widget.onDrawerClick,
                        products: products,
                        title: 'Liked Products',
                      ));
                    },
                    child:
                        getListTile(CupertinoIcons.heart, 'Liked Products', 3)),
                GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => HelpAndSupport()));
                      selectedIndex = 4;
                      widget.onChanged.call(HelpAndSupport(
                        onDrawerClick: widget.onDrawerClick,
                      ));
                    },
                    child: getListTile(Icons.headset, 'Help & Support', 4)),
                GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => YourAddresses()));
                      selectedIndex = 5;
                      widget.onChanged.call(YourAddresses(
                        onDrawerClick: widget.onDrawerClick,
                      ));
                    },
                    child: getListTile(
                        Icons.location_on_outlined, "Your Addresses", 5)),
                getListTile(Icons.bookmark_border, 'Privacy Policy', 6),
                getListTile(Icons.info_outline, 'About', 7),
                GestureDetector(
                    onTap: () {
                      GoogleSignIn().disconnect();
                      MyFirebaseAuth.firebaseAuth.signOut();
                      Navigator.pushReplacement(
                          context,
                          CustomPageRoute(
                              widget: LoginScreen(),
                              curve: Curves.easeOutExpo));
                    },
                    child: getListTile(Icons.logout, 'Logout', 8))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
              child: Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
