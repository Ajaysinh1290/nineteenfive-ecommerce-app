import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/load_data.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController pageController = PageController();
  int? selectedPage = 0;

  // TransformerPageController pageController =
  //     TransformerPageController(itemCount: 3);

  pushNextScreen(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 100));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyFirebaseAuth.firebaseAuth.currentUser == null
                    ? SignUpScreen()
                    : LoadData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: 3,
                controller: pageController,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                itemBuilder: (context, index) {
                  return Image.asset(
                    'assets/welcome-screen-poster/image-${index + 1}.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 28,
                    left: 28,
                    right: 28),
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black38, Colors.transparent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome to',
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            color: Colors.white,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w400)),
                    Text('Nineteenfive',
                        style: GoogleFonts.poppins(
                            fontSize: 40,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600)),
                    Text(
                        'Ready to start shopping.\nlet\'s explore together',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            letterSpacing: 0.8,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              PageView.builder(
                itemCount: 3,
                onPageChanged: (value) {
                  setState(() {
                    selectedPage = value;
                    pageController.animateToPage(selectedPage!,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOut);
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              ),
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.only(top: 40, left: 28, right: 28, bottom: 28),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black45],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: LongBlueButton(
          onPressed: () async {
            if (selectedPage! < 2) {
              setState(() {
                selectedPage = selectedPage! + 1;
                pageController.animateToPage(selectedPage!,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut);
              });
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.setBool('first_time', false);
              pushNextScreen(context);
            }
          },
          color: Colors.white,
          text: selectedPage != 2 ? 'Next' : 'Get Started',
        ),
      ),
    );
  }
}
