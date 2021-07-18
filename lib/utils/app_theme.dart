import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin AppThemeMixin {
  ThemeData get appThemeData => ThemeData(
      primaryColor: ColorPalette.blue,
      scaffoldBackgroundColor: ColorPalette.white,
      buttonColor: ColorPalette.blue,
      cursorColor: ColorPalette.black,
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: AppBarTheme(
          backgroundColor: ColorPalette.white,
          elevation: 0,
          iconTheme: IconThemeData(color: ColorPalette.black, size: 20),
          textTheme: TextTheme(
              headline1: GoogleFonts.poppins(
                  color: Colors.black,
                  letterSpacing: 0.5,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600),
          )),
      textTheme: TextTheme(
        caption: GoogleFonts.poppins(
            fontSize: 11.sp, letterSpacing: 1.2, fontWeight: FontWeight.w500),
        bodyText1: GoogleFonts.poppins(
            color: Colors.black,
            letterSpacing: 0.7,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600),
        bodyText2: GoogleFonts.poppins(
            color: Colors.black,
            letterSpacing: 0.5,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500),
        headline1: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: ColorPalette.black,
            fontSize: 32.sp,
            letterSpacing: 1),
        headline2: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: ColorPalette.darkGrey,
            fontSize: 28.sp,
            letterSpacing: 1),
        headline3: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: ColorPalette.black,
            fontSize: 22.sp,
            letterSpacing: 1),
        headline4: GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            color: ColorPalette.black,
            fontSize: 20.sp,
            letterSpacing: 1),
        headline5: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: ColorPalette.black,
            fontSize: 20.sp,
            letterSpacing: 1),
        headline6: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: ColorPalette.darkGrey,
            fontSize: 18.sp,
            letterSpacing: 1),
      ));
}
