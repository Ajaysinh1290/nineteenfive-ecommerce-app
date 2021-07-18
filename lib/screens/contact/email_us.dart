import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class EmailUs extends StatefulWidget {
  @override
  _EmailUsState createState() => _EmailUsState();
}

class _EmailUsState extends State<EmailUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: ScreenUtil().setWidth(25),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Email',
          style: Theme.of(context)
              .appBarTheme
              .textTheme!
              .headline1
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().setHeight(770),
          padding: EdgeInsets.symmetric(vertical: 25,horizontal: 20),
          child: Column(
            children: [
              BasicTextField(
                labelText: 'Email',

              ),
              SizedBox(height: ScreenUtil().setHeight(20),),
              BasicTextField(
                labelText: 'Title',
              ),
              SizedBox(height: ScreenUtil().setHeight(20),),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorPalette.lightGrey,
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(15))
                  ),
                  child: BasicTextField(
                    expanded: true,
                    labelText: 'Description',
                    textInputType: TextInputType.multiline,
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),
              LongBlueButton(text: 'Send Mail',onPressed: (){},),
            ],
          ),
        ),
      ),

    );
  }
}
