import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/screens/authentication/forgot_password_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/authentication/signup_screen.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/load_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_ecommerce_app/widgets/route/CustomPageRoute.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class EditEmail extends StatefulWidget {
  @override
  _EditEmailState createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  TextEditingController oldEmailController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  Future<void> validator(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      bool result = await MyFirebaseAuth(context)
          .updateEmail(emailController.text, passwordController.text);
      print(result);
      if (result) {
        Navigator.pop(context);
        Navigator.pop(context);
        await MyDialog.showMyDialog(context, 'Email Updated');
      }
    }
  }

  String? passwordValidator(value) {
    if (value.isEmpty)
      return "Required *";
    else if (value.length < 6)
      return "Should be at least 6 characters";
    else if (value.length > 15)
      return "Should not be more than 15 characters";
    else
      return null;
  }

  String? emailValidator(value) {
    if (value.isEmpty)
      return "Required *";
    else if (!value.toString().contains("@") || !value.toString().contains("."))
      return "Enter a Valid Email Address !";
    else
      return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oldEmailController.text = StaticData.userData.email;
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
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('Edit Email',
              style: Theme.of(context).appBarTheme.textTheme!.headline1),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BasicTextField(
                    labelText: 'Old Email Address',
                    textInputType: TextInputType.emailAddress,
                    controller: oldEmailController,
                    readOnly: true,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  BasicTextField(
                    labelText: 'New Email Address',
                    validator: emailValidator,
                    textInputType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    controller: emailController,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  BasicTextField(
                    labelText: 'Password',
                    validator: passwordValidator,
                    obscureText: true,
                    controller: passwordController,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                  ),
                  LongBlueButton(
                    text: 'Update Email',
                    onPressed: () => validator(context),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
