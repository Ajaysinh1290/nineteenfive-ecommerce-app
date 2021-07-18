import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nineteenfive_ecommerce_app/screens/authentication/change_password.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/screens/authentication/edit_email.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class YourProfile extends StatefulWidget {
  final Function? onDrawerClick;

  YourProfile({this.onDrawerClick});

  @override
  _YourProfileState createState() => _YourProfileState();
}

class _YourProfileState extends State<YourProfile> {
  late User user;
  File? image;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileNumberController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  GlobalKey<FormState> formKey = GlobalKey();
  String? imageUrl;


  double angle = 0;
  late Timer timer;

  Future<void> validate(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (image != null) {
        await uploadFile();
      }
      MyFirebaseAuth myFirebaseAuth = MyFirebaseAuth(context);
      bool result = await myFirebaseAuth.updateData(nameController.text,mobileNumberController.text, imageUrl ?? '');
      if (result) {
        // Navigator.pop(context);
      }
    }
  }

  String? passwordValidator(value) {
    if (value.isEmpty)
      return null;
    else if (value.length < 6)
      return "Should be at least 6 characters";
    else if (value.length > 15)
      return "Should not be more than 15 characters";
    else
      return null;
  }

  String? confirmPasswordValidator(value) {
    if (passwordController.text.isNotEmpty && passwordController.text != value)
      return "Confirm password not matched..!";
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

  String? validator(value) {
    if (value.isEmpty)
      return "Required *";
    else
      return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = MyFirebaseAuth.firebaseAuth.currentUser!;
    nameController = TextEditingController(text: user.displayName);
    emailController = TextEditingController(text: user.email);
    mobileNumberController = TextEditingController(text: StaticData.userData.mobileNumber);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    timer = Timer.periodic(Duration(milliseconds: 250), (timer) {
      setState(() {
        angle += 10;

      });
    });
  }

  @override
  void dispose() {
    super.dispose();
      timer.cancel();

  }

  getEditButton() {
    return GestureDetector(
      onTap: getImage,
      child: Container(
        width: ScreenUtil().setWidth(33),
        height: ScreenUtil().setWidth(33),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          color: ColorPalette.lightGrey,
        ),
        child: Icon(
          Icons.edit,
          color: Colors.black,
          size: ScreenUtil().setWidth(18),
        ),
      ),
    );
  }

  Future getImage() async {
    print('In Picker');
    var pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('no image selected');
    }
    setState(() {});
  }

  Future<void> uploadFile() async {
    try {
      await FirebaseStorage.instance
          .ref('users/' + user.uid + ".jpg")
          .putFile(image!);
      await getDownloadUrl();
    } on FirebaseException catch (_) {}
  }

  Future<void> getDownloadUrl() async {
    imageUrl = await FirebaseStorage.instance
        .ref('users/' + user.uid + ".jpg")
        .getDownloadURL();
    print(imageUrl);
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
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                widget.onDrawerClick!();
              }
            }),
        title: Text('Your Profile',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            widget.onDrawerClick!();
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/full_colored_circle.png',
                        width: ScreenUtil().setWidth(192),
                        height: ScreenUtil().setWidth(192),
                      ),
                      RotationTransition(
                          turns: AlwaysStoppedAnimation(angle / 360),
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            width: ScreenUtil().setWidth(232),
                            height: ScreenUtil().setWidth(232),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/icons/half_colored_circle.png',
                                  width: ScreenUtil().setWidth(232),
                                  height: ScreenUtil().setWidth(232),
                                ),
                                // Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Container(
                                //     width: 8,
                                //     height: 8,
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       color: ColorPalette.black.withOpacity(0.8)
                                //     ),
                                //   ),
                                // ),
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: Container(
                                //     width: 8,
                                //     height: 8,
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       color: Colors.red
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          )),
                      Stack(
                        children: [
                          image != null
                              ? ClipOval(
                                  child: Image.file(
                                  image!,
                                  width: ScreenUtil().setWidth(152),
                                  height: ScreenUtil().setWidth(152),
                                  fit: BoxFit.cover,
                                ))
                              : user.photoURL != null
                                  ? ClipOval(
                                      child: ImageNetwork(
                                        width: ScreenUtil().setWidth(152),
                                        height: ScreenUtil().setWidth(152),
                                        fit: BoxFit.cover,
                                        imageUrl: user.photoURL ?? imageUrl!,
                                        errorIcon: CupertinoIcons.person_fill,
                                      ),
                                      //   child: Image.network(
                                      //   user.photoURL ?? imageUrl,
                                      //   height: ScreenUtil().setWidth(152),
                                      //   width: ScreenUtil().setWidth(152),
                                      //   fit: BoxFit.cover,
                                      // )
                                    )
                                  : Container(
                                      height: ScreenUtil().setWidth(152),
                                      width: ScreenUtil().setWidth(152),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorPalette.lightGrey,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.person_fill,
                                        size: ScreenUtil().setWidth(50),
                                        color: ColorPalette.darkGrey,
                                      ),
                                    ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: getEditButton(),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  BasicTextField(
                    labelText: 'Full Name',
                    controller: nameController,
                    validator: validator,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BasicTextField(
                    labelText: 'Email',
                    controller: emailController,
                    validator: emailValidator,
                    readOnly: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => EditEmail()))
                            .then((value) => setState(() {
                                  emailController.text =
                                      StaticData.userData.email;
                                }));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 22.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BasicTextField(
                    labelText: 'Mobile Number',
                    controller: mobileNumberController,
                    textInputType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  LongBlueButton(
                      text: 'Update', onPressed: () => validate(context)),
                  SizedBox(
                    height: 15,
                  ),
                  LongBlueButton(
                    onPressed: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=>ChangePassword()));
                    },
                    text: 'Change Password',
                    color: ColorPalette.lightGrey
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.all(20.0),
      //   child:
      //       LongBlueButton(text: 'Update', onPressed: () => validate(context)),
      // ),
    );
  }
}
