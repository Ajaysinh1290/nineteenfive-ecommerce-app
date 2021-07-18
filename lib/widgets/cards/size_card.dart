import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';

class SizeCard extends StatelessWidget {
  final String? size;
  final bool isSelected;
  final EdgeInsets? margin;
  final Color? selectedItemTextColor;

  const SizeCard(
      {Key? key,
      this.size,
      required this.isSelected,
      this.margin,
      this.selectedItemTextColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceOut,
      width: ScreenUtil().setWidth(size!.length>2?45:35),
      height: ScreenUtil().setWidth(35),
      alignment: Alignment.center,
      margin: margin ?? EdgeInsets.only(right: ScreenUtil().setWidth(15)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
          boxShadow: [
            isSelected
                ? BoxShadow(
                    color: ColorPalette.black.withOpacity(0.1),
                    offset: Offset(2, 2),
                    blurRadius: 2)
                : BoxShadow(
                    color: ColorPalette.black.withOpacity(0.1),
                    blurRadius: 2,
                  ),
            if (isSelected)
              BoxShadow(
                  color: ColorPalette.black.withOpacity(0.05),
                  offset: Offset(-1, -1),
                  blurRadius: 10)
          ]),
      child: Text(
        size!,
        style: GoogleFonts.openSans(
            fontSize: 16.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? selectedItemTextColor ?? ColorPalette.darkBlue
                : Colors.black),
      ),
    );
  }
}
