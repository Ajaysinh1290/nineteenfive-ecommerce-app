import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  GlobalKey<FormState>  formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  String? emailValidator(value) {
    if (value.isEmpty)
      return "Required *";
    else if (!value.toString().contains("@") || !value.toString().contains("."))
      return "Enter a Valid Email Address !";
    else
      return null;
  }

  Future<void> validator(BuildContext context) async {
    if(formKey.currentState!.validate()) {
      bool result = await MyFirebaseAuth(context).resetPassword(emailController.text);
      if(result) {
        emailController.text='';
        setState(() {

        });
      }
    }
  }

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
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-100,
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot Password ?',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ScreenUtil().setHeight(20),),
                Text(
                  'Enter the email address you used to create your account and we will email you a link to reset your password',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 35,),
                BasicTextField(
                  labelText: 'Email',
                  validator: emailValidator,
                  controller: emailController,
                ),
                SizedBox(height: ScreenUtil().setHeight(40),),
                LongBlueButton(
                  text: 'Send Mail',
                  onPressed: ()=>validator(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
