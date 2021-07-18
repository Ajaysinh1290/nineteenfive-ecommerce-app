import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/screens/authentication/forgot_password_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/authentication/signup_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/load_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/route/CustomPageRoute.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  Future<void> signInWithGoogle(BuildContext context) async {
    bool result = await MyFirebaseAuth(context).signInWithGoogle();
    if (result) {

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoadData()), (route) => false);
    }
  }

  Future<void> validator(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      bool result = await MyFirebaseAuth(context)
          .signIn(emailController.text, passwordController.text);
      if (result) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoadData()), (route) => false);

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

  String?  emailValidator(value) {
    if (value.isEmpty)
      return "Required *";
    else if (!value.toString().contains("@") || !value.toString().contains("."))
      return "Enter a Valid Email Address !";
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
              Text(
                'Hey,',
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                'Login Now.',
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
              BasicTextField(
                labelText: 'Email',
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
              GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                  Navigator.push(
                      context,
                      CustomPageRoute(
                          widget: ForgotPasswordScreen(),
                          curve: Curves.elasticOut,
                          alignment: Alignment.centerRight));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password ?',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: ColorPalette.darkGrey),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
              LongBlueButton(
                text: 'Login',
                onPressed: () => validator(context),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              GestureDetector(
                onTap: () => signInWithGoogle(context),
                child: Container(
                  height: ScreenUtil().setHeight(80),
                  decoration: BoxDecoration(
                      color: ColorPalette.white,
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(17)),
                      boxShadow: [
                        BoxShadow(
                            color: ColorPalette.black.withOpacity(0.08),
                            blurRadius: 15)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/google_icon.png',
                        width: ScreenUtil().setWidth(30.73),
                        height: ScreenUtil().setHeight(30),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                      Text(
                        'Sign in with Google',
                        style: Theme.of(context).textTheme.headline3,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Don\'t have an account ?',
                      style: Theme.of(context).textTheme.headline6,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            CustomPageRoute(
                                widget: SignUpScreen(),
                                alignment: Alignment.bottomCenter,
                                curve: Curves.elasticOut,
                                duration: Duration(milliseconds: 1000)));
                      },
                      child: Text(
                        'Sign up',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: ColorPalette.black,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
