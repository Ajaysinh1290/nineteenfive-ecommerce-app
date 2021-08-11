import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/size_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class AddProduct extends StatefulWidget {
  Product? product;

  AddProduct();

  AddProduct.editProduct(this.product);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late String selectedCategoryId;
  List<dynamic>? selectedSizes = [];
  List<File> images = [];
  List<dynamic> imageUrl = [];
  bool selectSizeError = false;
  bool selectImageError = false;
  List timeLabel = ["Day", "Month", "Year"];
  String? selectedTimeLabel;
  int? returnTimeDuration;
  bool isReturnable = false;

  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productMrpController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController availableStockController = TextEditingController();
  TextEditingController timeDurationController = TextEditingController();

  late ScrollController scrollController;
  late PageController pageController;
  int selectedImage = 0;
  List? sizes;
  List<String> imageUrlIds = [];

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();

    pageController = PageController(initialPage: selectedImage);

    if (widget.product != null) {
      productNameController.text = widget.product!.productName;
      productPriceController.text = widget.product!.productPrice.toString();
      productMrpController.text = (widget.product!.productMrp ?? '').toString();
      selectedCategoryId = widget.product!.productCategory;
      availableStockController.text = widget.product!.availableStock.toString();
      productDescriptionController.text = widget.product!.productDescription;
      imageUrl = widget.product!.productImages;
      selectedSizes = widget.product!.productSizes!;
      if (widget.product!.returnTime != null) {
        returnTimeDuration = int.parse(widget.product!.returnTime!
            .substring(0, widget.product!.returnTime!.indexOf(" ")));
        selectedTimeLabel = widget.product!.returnTime!.substring(
            widget.product!.returnTime!.indexOf(" ") + 1,
            returnTimeDuration! > 1
                ? widget.product!.returnTime!.length - 1
                : widget.product!.returnTime!.length);
        isReturnable = true;
      }
    } else {
      selectedCategoryId = StaticData.categoriesList.first.categoryId;
    }
    if (returnTimeDuration == null) {
      selectedTimeLabel = timeLabel.first;
      returnTimeDuration = 1;
    }
    timeDurationController.text = returnTimeDuration.toString();
  }

  Future getImage() async {
    print('In Picker');
    var pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  String? validator(value) {
    if (value.isEmpty) {
      return "* Required";
    } else {
      return null;
    }
  }

  String? numValidator(value) {
    if (value.isEmpty) {
      return "* Required";
    } else {
      try {
        int.parse(value);
        return null;
      } catch (e) {
        return "Only numbers are allowed !";
      }
    }
  }

  validate() async {
    bool formValidateResult = formKey.currentState!.validate();
    bool sizeValidateResult = sizeValidate();
    bool imageValidateResult = imageValidate();
    if (formValidateResult && sizeValidateResult && imageValidateResult) {
      if (widget.product != null) {
        updateProduct();
      } else {
        addNewProduct();
      }
    }
  }

  updateProduct() async {
    MyDialog.showLoading(context);
    await uploadImages(widget.product!.productId);
    print('Image uploaded');
    print(imageUrl);
    widget.product!.productName = productNameController.text.trim();
    widget.product!.productPrice = int.parse(productPriceController.text);
    widget.product!.productMrp = productMrpController.text.isNotEmpty
        ? int.parse(productMrpController.text)
        : null;
    widget.product!.productCategory = selectedCategoryId;
    widget.product!.productSizes = selectedSizes;
    widget.product!.productImages = imageUrl;
    widget.product!.productDescription =
        productDescriptionController.text.trim();
    widget.product!.availableStock = int.parse(availableStockController.text);
    widget.product!.returnTime = isReturnable
        ? timeDurationController.text +
            " " +
            selectedTimeLabel! +
            (returnTimeDuration! > 1 ? 's' : '')
        : null;

    await FirebaseDatabase.storeProduct(widget.product);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  addNewProduct() async {
    String productId = DateTime.now().millisecondsSinceEpoch.toString();
    MyDialog.showLoading(context);
    await uploadImages(productId);
    print('Image uploaded');
    print(imageUrl);
    print(productId);
    Product product = Product(
        productId: productId,
        isActive : true,
        isFeatured : true,
        productName: productNameController.text.trim(),
        productMrp: productMrpController.text.isNotEmpty
            ? int.parse(productMrpController.text)
            : null,
        productPrice: int.parse(productPriceController.text),
        productCategory: selectedCategoryId,
        productSizes: selectedSizes,
        productImages: imageUrl,
        productDescription: productDescriptionController.text.trim(),
        productCreatedOn: DateTime.now(),
        returnTime: isReturnable
            ? timeDurationController.text +
                " " +
                selectedTimeLabel! +
                (returnTimeDuration! > 1 ? 's' : '')
            : null,
        availableStock: int.parse(availableStockController.text));
    StaticData.products.add(product);
    await FirebaseDatabase.storeProduct(product);
    Navigator.pop(context);
    Navigator.pop(context);
    // await MyDialog.showMyDialog(
    //     context, 'Product successfully added to Database');
    // Navigator.pop(context);
    // Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => ItemDetails(product)))
    //     .then((value) {
    //   imageUrl.clear();
    //   images.clear();
    //   productDescriptionController.clear();
    //   productNameController.clear();
    //   productPriceController.clear();
    //   productMrpController.clear();
    //   selectedSizes.clear();
    //   availableStockController.clear();
    //   selectedCategoryId = '';
    //   selectedImage = 0;
    // });
  }

  bool sizeValidate() {
    if (sizes != null && sizes!.isNotEmpty && selectedSizes!.isEmpty) {
      setState(() {
        selectSizeError = true;
      });
      return false;
    } else {
      setState(() {
        selectSizeError = false;
      });

      return true;
    }
  }

  bool imageValidate() {
    if (images.length == 0 && imageUrl.length == 0) {
      setState(() {
        selectImageError = true;
      });
      return false;
    } else {
      setState(() {
        selectImageError = false;
      });
      return true;
    }
  }

  Future<void> uploadImages(String? productId) async {
    try {
      for (int i = imageUrl.length; i < imageUrl.length + images.length; i++) {
        String imageUrlId =(DateTime.now().toString())+(i.toString());
        await FirebaseStorage.instance
            .ref('products/' +
                productId! +
                '/'+imageUrlId+
                ".jpg")
            .putFile(images[i - imageUrl.length]);
        imageUrlIds.add(imageUrlId);
      }
      await getImageUrl(productId!);
    } on FirebaseException catch (_) {}
  }

  Future<void> getImageUrl(String? productId) async {

    int length = imageUrl.length +images.length;
    for (int i = imageUrl.length,j=0 ; i < length; i++,j++) {
      String url = await FirebaseStorage.instance
          .ref('products/' +
              productId! +
              '/'+imageUrlIds[j]+
              ".jpg")
          .getDownloadURL();
      imageUrl.add(url);
    }
  }

  Future<void> deleteUrl(String imageUrl) async {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }

  @override
  Widget build(BuildContext context) {
    StaticData.categoriesList.forEach((element) {
      if (element.categoryId == selectedCategoryId) {
        sizes = element.sizes;
      }
    });
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
        title: Text(widget.product == null ? 'Add Product' : 'Update Product',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(28),
                ),
                Container(
                  height: ScreenUtil().setHeight(500),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().radius(35))),
                  child: images.length == 0 && imageUrl.length == 0
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(30)),
                          color: ColorPalette.lightGrey,
                          child: Icon(
                            Icons.image,
                            size: 50.sp,
                            color: Colors.grey,
                          ),
                        )
                      : Stack(
                          children: [
                            PageView.builder(
                              itemCount: images.length + imageUrl.length,
                              scrollDirection: Axis.horizontal,
                              controller: pageController,
                              onPageChanged: (value) {
                                if (selectedImage > value ||
                                    selectedImage >= 6) {
                                  scrollController.animateTo((value - 1) * 18.0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeOutExpo);
                                }
                                setState(() {
                                  selectedImage = value;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                             ScreenUtil().setWidth(30)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().radius(35)),
                                        child: index >= imageUrl.length
                                            ? Image.file(
                                                images[index - imageUrl.length],
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              )
                                            : ImageNetwork(
                                                imageUrl: imageUrl[index],
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                          height: double.infinity,
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: ScreenUtil().setWidth(30),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            size: 30.sp,
                                            color: ColorPalette.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (index < imageUrl.length) {
                                                deleteUrl(imageUrl.removeAt(index));
                                              } else {
                                                images.removeAt(index-imageUrl.length);
                                              }
                                            });
                                          },
                                        ),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12,
                                                  Colors.transparent
                                                ],
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(
                                                  ScreenUtil().radius(35),
                                                ),
                                                bottomLeft: Radius.circular(
                                                    ScreenUtil().radius(35)))),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            if (images.length + imageUrl.length > 1)
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 10,
                                  width: 125,
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Center(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      controller: scrollController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          images.length + imageUrl.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            pageController.animateToPage(index,
                                                duration: Duration(seconds: 2),
                                                curve: Curves.elasticOut);
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: index == selectedImage
                                                    ? 0
                                                    : 1),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: index == selectedImage
                                                  ? ColorPalette.lightGrey
                                                  : ColorPalette.white
                                                      .withOpacity(0.3),
                                            ),
                                            width:
                                                index == selectedImage ? 10 : 8,
                                            height: 10,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
                if (selectImageError)
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
                  height: ScreenUtil().setHeight(30),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: ScreenUtil().setWidth(28)),
                  child: Column(
                    children: [
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
                            'Add Image',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(40),
                      ),
                      BasicTextField(
                        labelText: 'Product Name',
                        validator: validator,
                        controller: productNameController,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      BasicTextField(
                        labelText: 'Product Price',
                        suffixText: Constants.currencySymbol,
                        textInputType: TextInputType.number,
                        validator: numValidator,
                        controller: productPriceController,
                        enableInteractiveSelection: false,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      BasicTextField(
                        labelText: 'Product MRP',
                        suffixText: Constants.currencySymbol,
                        textInputType: TextInputType.number,
                        controller: productMrpController,
                        enableInteractiveSelection: false,
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
                                selectedSizes!.clear();
                                selectedCategoryId = value.toString();
                              });
                            },
                            items: List.generate(
                                StaticData.categoriesList.length, (index) {
                              return DropdownMenuItem(
                                value:
                                    StaticData.categoriesList[index].categoryId,
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
                      if (sizes != null && sizes!.isNotEmpty)
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Sizes',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (selectSizeError)
                                    Text(
                                      '* Required',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            color: Colors.red,
                                          ),
                                    )
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Wrap(
                                alignment: WrapAlignment.start,
                                children: List.generate(sizes!.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selectedSizes!
                                            .contains(sizes![index])) {
                                          selectedSizes!.remove(sizes![index]);
                                        } else {
                                          selectedSizes!.add(sizes![index]);
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(15)),
                                      child: SizeCard(
                                        size: sizes![index],
                                        isSelected: selectedSizes!
                                            .contains(sizes![index]),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Returnable',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(fontSize: 20.sp),
                            ),
                            Switch(
                                value: isReturnable,
                                activeColor: Colors.white,
                                activeTrackColor: ColorPalette.darkBlue,
                                onChanged: (value) {
                                  setState(() {
                                    isReturnable = value;
                                  });
                                })
                          ],
                        ),
                      ),
                      if (isReturnable)
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                      if (isReturnable)
                        Row(
                          children: [
                            Expanded(
                              child: BasicTextField(
                                labelText: 'Time Duration',
                                textInputType: TextInputType.number,
                                validator: numValidator,
                                enableInteractiveSelection: false,
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isNotEmpty) {
                                      returnTimeDuration = int.parse(value);
                                    }
                                  });
                                },
                                controller: timeDurationController,
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(15),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.center,
                                height: ScreenUtil().setHeight(80),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().radius(15)),
                                    color: ColorPalette.lightGrey),
                                child: DropdownButton(
                                    underline: DropdownButtonHideUnderline(
                                      child: Container(),
                                    ),
                                    dropdownColor: ColorPalette.lightGrey,
                                    isDense: true,
                                    isExpanded: true,
                                    iconEnabledColor: Colors.black,
                                    value: selectedTimeLabel,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedTimeLabel = value.toString();
                                      });
                                    },
                                    items: List.generate(timeLabel.length,
                                        (index) {
                                      return DropdownMenuItem(
                                        value: timeLabel[index],
                                        child: Text(
                                          timeLabel[index] +
                                              (returnTimeDuration! > 1
                                                  ? 's'
                                                  : ''),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(color: Colors.black),
                                        ),
                                      );
                                    })),
                              ),
                            )
                          ],
                        ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      BasicTextField(
                        labelText: 'Available Stock',
                        textInputType: TextInputType.number,
                        validator: numValidator,
                        enableInteractiveSelection: false,
                        controller: availableStockController,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(400),
                        decoration: BoxDecoration(
                            color: ColorPalette.lightGrey,
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().radius(15))),
                        child: BasicTextField(
                          expanded: true,
                          textInputType: TextInputType.multiline,
                          labelText: 'Product Description',
                          validator: validator,
                          controller: productDescriptionController,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(40),
                      ),
                      LongBlueButton(
                        text: widget.product != null
                            ? 'Update Product'
                            : 'Add Product',
                        onPressed: () {
                          validate();
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
