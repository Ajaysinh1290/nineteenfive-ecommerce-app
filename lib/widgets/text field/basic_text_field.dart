import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';

class BasicTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final bool? obscureText;
  final bool? expanded;
  final TextInputType? textInputType;
  final String? suffixText;
  final FocusNode? focusNode;
  final TextCapitalization? textCapitalization;
  final Function(String)? onChanged;
  final bool? enableInteractiveSelection;
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Color? color;

  const BasicTextField(
      {Key? key,
      required this.labelText,
      this.controller,
      this.validator,
      this.expanded,
      this.obscureText,
      this.textInputType,
      this.suffixText,
      this.textCapitalization,
      this.focusNode,
      this.onChanged,
      this.readOnly,
      this.enableInteractiveSelection,
        this.color,
      this.inputFormatters, this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
      child: TextFormField(
        maxLines: expanded ?? false ? null : 1,
        validator: validator,
        readOnly: readOnly??false,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        autovalidateMode: AutovalidateMode.disabled,
        enableInteractiveSelection: enableInteractiveSelection ?? true,
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        keyboardType: textInputType ?? TextInputType.name,
        obscureText: obscureText ?? false,
        cursorColor: Theme.of(context).cursorColor,
        decoration: InputDecoration(
            fillColor: color??ColorPalette.lightGrey,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(15),
                horizontal: ScreenUtil().setWidth(10)),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
                borderSide: BorderSide(color: color??ColorPalette.lightGrey)),
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
                borderSide: BorderSide(color: color??ColorPalette.lightGrey)),
            errorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
                borderSide: BorderSide(color: color??ColorPalette.lightGrey)),
            focusedErrorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
                borderSide: BorderSide(color: color??ColorPalette.lightGrey)),
            suffixStyle: GoogleFonts.openSans(
                fontSize: 22.sp, letterSpacing: 0.5, fontWeight: FontWeight.w500),
            suffixText: suffixText,
            suffixIcon: suffixIcon,
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.headline6),
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: ColorPalette.black, height: 1.8),
      ),
    );
  }
}
