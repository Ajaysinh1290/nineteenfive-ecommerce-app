import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LongBlueButton extends StatelessWidget {
  final GestureTapCallback? onPressed;
  final String? text;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? color;

  const LongBlueButton(
      {Key? key,
      required this.onPressed,
      this.text,
      this.width,
      this.height,
      this.textStyle,
      this.color,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: ScreenUtil().setWidth(width ?? 410),
        height: ScreenUtil().setHeight(height ?? 75),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color ?? Theme.of(context).buttonColor,
            borderRadius:
                BorderRadius.circular(ScreenUtil().radius(borderRadius ?? 17))),
        child: Text(
          text ?? '',
          style: textStyle ?? Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
