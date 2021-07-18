import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'dart:async';
import 'dart:io';

import 'package:nineteenfive_ecommerce_app/models/poster.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class AddPoster extends StatefulWidget {
  Poster? poster;

  AddPoster({Key? key}) : super(key: key);

  AddPoster.updatePoster(this.poster);

  @override
  _AddPosterState createState() => _AddPosterState();
}

class _AddPosterState extends State<AddPoster> {
  File? image;
  String? imageUrl;
  double height = 210;
  late String selectedCategoryId;
  late String selectedPosition;
  List positions = ["Top", "Bottom"];
  TextEditingController categoryNameController = TextEditingController();
  List<FocusNode> focusNodes = [];
  List<TextEditingController> sizeControllers = [];
  GlobalKey<FormState> formKey = GlobalKey();
  bool validateImageError = false;
  ScrollController scrollController = ScrollController();

  int productMinOff = 0;
  int productMaxOff = 0;
  int productMinPrice = 0;
  int productMaxPrice = 0;

  Future getImage() async {
    print('In Picker');
    var pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  validate() async {
    bool imageValidate = validateImage();
    bool formValidate = formKey.currentState!.validate();
    if (imageValidate && formValidate) {
      addPoster();
    }
  }

  addPoster() async {
    String posterId = DateTime.now().millisecondsSinceEpoch.toString();
    await uploadFile(posterId);
    Poster poster = Poster(
        imageUrl: imageUrl ?? '',
        position: selectedPosition,
        categoryId: selectedCategoryId,
        posterId: posterId,
        maxAmount: productMaxPrice,
        minAmount: productMinPrice,
        maxOff: productMaxOff,
        minOff: productMinOff);
    MyDialog.showLoading(context);
    await FirebaseDatabase.storePoster(poster);
    Navigator.pop(context);
    MyDialog.showMyDialog(context, "Poster Published");
  }

  String? validator(value) {
    if (value.isEmpty) {
      return "* Required";
    } else {
      return null;
    }
  }

  bool validateImage() {
    if (image != null) {
      setState(() {
        validateImageError = false;
      });
      return true;
    } else {
      setState(() {
        validateImageError = true;
      });
      return false;
    }
  }

  Future<bool> uploadFile(String posterId) async {
    try {
      await FirebaseStorage.instance
          .ref('posters/' + posterId + ".jpg")
          .putFile(image!);
      await getDownloadUrl(posterId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getDownloadUrl(String posterId) async {
    imageUrl = await FirebaseStorage.instance
        .ref('posters/' + posterId + ".jpg")
        .getDownloadURL();
    print(imageUrl);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCategoryId = StaticData.categoriesList.first.categoryId;
    selectedPosition = positions.first;
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
        title: Text(widget.poster != null ? 'Update Poster' : 'New Poster',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 28, vertical: ScreenUtil().setHeight(28)),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: height),
                    // padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().radius(17)),
                        color: ColorPalette.lightGrey),
                    child: image != null
                        ? Image.file(
                            image!,
                            fit: BoxFit.fitWidth,
                          )
                        : imageUrl != null
                            ? ImageNetwork(
                                imageUrl: imageUrl!,
                                fit: BoxFit.fitWidth,
                              )
                            : SizedBox(
                                height: ScreenUtil().setHeight(height),
                                child: Icon(
                                  Icons.image,
                                  size: 50.sp,
                                  color: ColorPalette.grey,
                                ),
                              )),
                if (validateImageError)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 10),
                    child: Text(
                      '* Image required',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ),
                SizedBox(
                  height: ScreenUtil().setHeight(40),
                ),
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    height: ScreenUtil().setHeight(65),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.black),
                    ),
                    child: Text(
                      widget.poster != null || image != null
                          ? 'Change Image'
                          : 'Add Image',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(80),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().radius(15)),
                      color: ColorPalette.lightGrey),
                  child: DropdownButton(
                      underline: DropdownButtonHideUnderline(
                        child: Container(),
                      ),
                      dropdownColor: ColorPalette.lightGrey,
                      isDense: true,
                      isExpanded: true,
                      iconEnabledColor: Colors.black,
                      value: selectedCategoryId,
                      icon: Icon(Icons.keyboard_arrow_down),
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryId = value.toString();
                        });
                      },
                      items: List.generate(StaticData.categoriesList.length,
                          (index) {
                        return DropdownMenuItem(
                          value: StaticData.categoriesList[index].categoryId,
                          child: Text(
                            StaticData.categoriesList[index].categoryName,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.black),
                          ),
                        );
                      })),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(80),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().radius(15)),
                      color: ColorPalette.lightGrey),
                  child: DropdownButton(
                      underline: DropdownButtonHideUnderline(
                        child: Container(),
                      ),
                      dropdownColor: ColorPalette.lightGrey,
                      isDense: true,
                      isExpanded: true,
                      iconEnabledColor: Colors.black,
                      value: selectedPosition,
                      icon: Icon(Icons.keyboard_arrow_down),
                      onChanged: (value) {
                        setState(() {
                          selectedPosition = value.toString();
                        });
                      },
                      items: List.generate(positions.length, (index) {
                        return DropdownMenuItem(
                          value: positions[index],
                          child: Text(
                            positions[index],
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.black),
                          ),
                        );
                      })),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                BasicTextField(
                  labelText: 'Product Min Price',
                  textInputType: TextInputType.number,
                  enableInteractiveSelection: false,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  suffixText: Constants.currencySymbol,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      productMinPrice = int.parse(value);
                    } else {
                      productMinPrice = 0;
                    }
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                BasicTextField(
                  labelText: 'Product Max Price',
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      productMaxPrice = int.parse(value);
                    } else {
                      productMaxPrice = 0;
                    }
                  },
                  textInputType: TextInputType.number,
                  enableInteractiveSelection: false,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  suffixText: Constants.currencySymbol,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product Min Off',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        productMinOff.toString() + "%",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(12),
                ),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().radius(15)),
                    color: ColorPalette.lightGrey,
                  ),
                  child: Slider(
                    value: productMinOff.toDouble(),
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        productMinOff = value.toInt();
                      });
                    },
                    activeColor: ColorPalette.darkBlue,
                    inactiveColor: ColorPalette.grey,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(12),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product Max Off',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        productMaxOff.toString() + "%",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(12),
                ),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().radius(15)),
                    color: ColorPalette.lightGrey,
                  ),
                  child: Slider(
                    value: productMaxOff.toDouble(),
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        productMaxOff = value.toInt();
                      });
                    },
                    activeColor: ColorPalette.darkBlue,
                    inactiveColor: ColorPalette.grey,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                LongBlueButton(
                  text: widget.poster != null
                      ? 'Update Poster'
                      : 'Publish Poster',
                  onPressed: () => validate(),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
