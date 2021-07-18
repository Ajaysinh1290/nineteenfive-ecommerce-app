import 'package:flutter/material.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              28,
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Confirm OTP',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Enter the OTP we just sent your email address',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: PinCodeTextField(
                    appContext: context,
                    animationCurve: Curves.easeInOut,
                    animationType: AnimationType.scale,
                    enableActiveFill: true,
                    enabled: true,
                    cursorColor: Theme.of(context).cursorColor,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldWidth: 45,
                      borderRadius: BorderRadius.circular(10),
                      activeFillColor:  ColorPalette.lightGrey,
                      activeColor: ColorPalette.lightGrey,
                      inactiveColor: ColorPalette.lightGrey,
                      inactiveFillColor: ColorPalette.lightGrey,
                      selectedFillColor: ColorPalette.lightGrey,
                      selectedColor: ColorPalette.lightGrey,

                    ),

                    textStyle: Theme.of(context).textTheme.headline5,
                    length: 4,
                    onChanged: (value) {}),
              ),
              SizedBox(
                height: 40,
              ),
              LongBlueButton(
                text: 'Confirm',
                onPressed: (){

                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
