import 'package:flutter/material.dart';

class ColorPalette {
  static const Color blue = Color(0xffAAEBFF);
  static const Color darkBlue = Color(0xff1AC2F8);
  static const  Color black = Color(0xff000000);
  static const  Color grey = Color(0xffCCCCCC);
  static const  Color darkGrey = Color(0xffB1B1B1);
  static const  Color lightGrey = Color(0xffF8F8F8);
  static const  Color white = Color(0xffFFFFFF);
  static const  Color red = Color(0xffFF2F2F);
  static const  LinearGradient blueGradient = LinearGradient(
      colors: [Color(0xffE1F8FF), Color(0xffAAEBFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  static const  Color yellow = Color(0xffFFC700);
}
