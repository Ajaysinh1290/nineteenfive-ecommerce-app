import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/models/category.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

import '../../utils/data/static_data.dart';

class AddCategory extends StatefulWidget {
  Category? category;

  AddCategory();

  AddCategory.editCategory(this.category);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  File? image;
  String? imageUrl;
  TextEditingController categoryNameController = TextEditingController();
  List<FocusNode> focusNodes = [];
  List<TextEditingController> sizeControllers = [];
  GlobalKey<FormState> formKey = GlobalKey();
  bool validateImageError = false;
  ScrollController scrollController = ScrollController();

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
      List sizes = [];
      sizeControllers.forEach((element) {
        sizes.add(element.text);
      });
      if (widget.category != null) {
        updateCategory(sizes);
      } else {
        addNewCategory(sizes);
      }
    }
  }

  addNewCategory(sizes) async {
    String categoryId = DateTime.now().millisecondsSinceEpoch.toString();
    print(categoryId);
    await uploadFile(categoryId);
    Category category = Category(
        categoryId: categoryId,
        categoryName: categoryNameController.text,
        imageUrl: imageUrl??'',
        sizes: sizes);
    await FirebaseDatabase.storeCategory(category);
    Navigator.pop(context);
    MyDialog.showMyDialog(context, 'New Category Added');
  }

  updateCategory(sizes) async {
    MyDialog.showLoading(context);
    await uploadFile(widget.category!.categoryId);
    widget.category!.categoryName = categoryNameController.text;
    widget.category!.imageUrl = imageUrl??'';
    widget.category!.sizes = sizes;
    await FirebaseDatabase.storeCategory(widget.category);
    Navigator.pop(context);
    MyDialog.showMyDialog(context, 'Category Updated');
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

  Future<bool> uploadFile(String categoryId) async {
    try {
      await FirebaseStorage.instance
          .ref('categories/' + categoryId + ".jpg")
          .putFile(image!);
      await getDownloadUrl(categoryId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getDownloadUrl(String categoryId) async {
    imageUrl = await FirebaseStorage.instance
        .ref('categories/' + categoryId + ".jpg")
        .getDownloadURL();
    print(imageUrl);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.category != null) {
      imageUrl = widget.category!.imageUrl;
      categoryNameController.text = widget.category!.categoryName;
      if (widget.category!.sizes != null) {
        widget.category!.sizes!.forEach((element) {
          sizeControllers.add(TextEditingController(text: element));
          focusNodes.add(FocusNode());
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
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
            widget.category != null ? 'Update Category' : 'Add Category',
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
                    height: ScreenUtil().setHeight(250),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().radius(17)),
                        color: ColorPalette.lightGrey),
                    child: Hero(
                      tag: widget.category!.categoryId,
                      child: image != null
                          ? Image.file(
                              image!,
                              fit: BoxFit.contain,
                            )
                          : imageUrl != null
                              ? ImageNetwork(
                                  imageUrl: imageUrl!,
                                )
                              : Icon(
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
                      widget.category != null || image != null
                          ? 'Change Image'
                          : 'Add Image',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                BasicTextField(
                  labelText: 'Category Name',
                  controller: categoryNameController,
                  validator: validator,
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
                        'Sizes',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              sizeControllers.add(TextEditingController());
                              focusNodes.add(FocusNode());
                            });
                            setState(() {
                              focusNodes[focusNodes.length - 1].requestFocus();
                              scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeOut);
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            size: ScreenUtil().setWidth(30),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: sizeControllers.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: BasicTextField(
                              labelText: 'Size',
                              controller: sizeControllers[index],
                              focusNode: focusNodes[index],
                              textCapitalization: TextCapitalization.characters,
                              textInputType: TextInputType.text,
                              validator: validator,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: LongBlueButton(
                              text: 'Delete',
                              onPressed: () {
                                setState(() {
                                  sizeControllers.removeAt(index);
                                  focusNodes.removeAt(index);
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                LongBlueButton(
                  text: widget.category != null
                      ? 'Update Category'
                      : 'Add Category',
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
