import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/product/item_details.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/product_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/size_card.dart';

class Products extends StatefulWidget {
  Function? onDrawerClick;
  final List<Product> products;
  String title;

  Products({this.onDrawerClick, required this.products, required this.title});

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List sortByList = [
    "Featured",
    "Price : Low to High",
    "Price : High to Low",
    "New Arrivals",
  ];
  int? discount;
  int? minPrice;
  int? maxPrice;
  int? minPriceInAllProducts;
  int? maxPriceInAllProducts;
  String? sortBy;
  List<String> categoriesList = [];
  List<List<String>> selectedSizes = [];
  List<Product> filteredProducts = [];
  bool showDiscountTag = false;
  List<bool> selectedCategory = [];

  int? getMinPrice() {
    if (minPriceInAllProducts != null) {
      return minPriceInAllProducts;
    }
    minPriceInAllProducts = getMaxPrice() ?? 99999999999999;
    widget.products.forEach((element) {
      if (element.productPrice < minPriceInAllProducts!) {
        minPriceInAllProducts = element.productPrice;
      }
    });
    return minPriceInAllProducts;
  }

  int? getMaxPrice() {
    if (maxPriceInAllProducts != null) {
      return maxPriceInAllProducts;
    }
    maxPriceInAllProducts = 0;

    widget.products.forEach((element) {
      if (element.productPrice > maxPriceInAllProducts!) {
        maxPriceInAllProducts = element.productPrice;
      }
    });
    return maxPriceInAllProducts;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.products.forEach((element) {
      if (!categoriesList.contains(element.productCategory)) {
        categoriesList.add(element.productCategory);
        selectedSizes.add([]);
        selectedCategory.add(true);
      }
    });
    widget.products.forEach((element) {
      filteredProducts.add(element);
    });

    sortBy = sortByList.first;
    discount = 0;
    minPrice = getMinPrice();
    maxPrice = getMaxPrice();
  }

  getCategoryName(String categoryId) {
    for (int i = 0; i < StaticData.categoriesList.length; i++) {
      if (StaticData.categoriesList[i].categoryId == categoryId) {
        return StaticData.categoriesList[i].categoryName;
      }
    }
  }

  categoryHasSizes(String categoryId) {
    for (int i = 0; i < StaticData.categoriesList.length; i++) {
      if (StaticData.categoriesList[i].categoryId == categoryId) {
        return StaticData.categoriesList[i].sizes != null &&
            StaticData.categoriesList[i].sizes!.isNotEmpty;
      }
    }
  }

  getSizes(String categoryId) {
    for (int i = 0; i < StaticData.categoriesList.length; i++) {
      if (StaticData.categoriesList[i].categoryId == categoryId) {
        return StaticData.categoriesList[i].sizes;
      }
    }
  }

  filterItemsDialog() {
    print('Min Price = $minPrice');
    print('Max Price = $maxPrice');
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              title: Container(
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Filter',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(CupertinoIcons.sort_down)
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: ColorPalette.lightGrey,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(3),
                    ),
                  ],
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    Text('Sort By',
                        style: Theme.of(context).textTheme.headline5),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    Column(
                      children: List.generate(
                        sortByList.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              setState.call(() {
                                sortBy = sortByList[index];
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  sortByList[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: Colors.black),
                                ),
                                Spacer(),
                                Radio(
                                    value: sortByList[index],
                                    activeColor: ColorPalette.darkBlue,
                                    groupValue: sortBy,
                                    onChanged: (dynamic value) {
                                      setState.call(() {
                                        sortBy = value.toString();
                                      });
                                    })
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount',
                            style: Theme.of(context).textTheme.headline5),
                        Text(
                          "${discount.toString()}% & above",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(80),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().radius(15)),
                        color: ColorPalette.lightGrey,
                      ),
                      child: Slider(
                        value: discount!.toDouble(),
                        min: 0,
                        max: 90,
                        divisions: 9,
                        onChanged: (value) {
                          setState(() {
                            discount = value.toInt();
                          });
                        },
                        activeColor: ColorPalette.darkBlue,
                        inactiveColor: ColorPalette.grey,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Show Discount Tag",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.black),
                        ),
                        Checkbox(
                            value: showDiscountTag,
                            activeColor: ColorPalette.darkBlue,
                            onChanged: (value) {
                              setState.call(() {
                                showDiscountTag = value!;
                              });
                            })
                      ],
                    ),
                    if (maxPrice != minPrice)
                      Column(
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Price Range',
                                  style: Theme.of(context).textTheme.headline5),
                              Text(
                                  "$minPrice${Constants.currencySymbol} - $maxPrice${Constants.currencySymbol}",
                                  style: GoogleFonts.openSans(
                                      fontSize: 18.sp,
                                      color: Colors.black,
                                      letterSpacing: 0.8,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(30),
                          ),
                          Container(
                            height: ScreenUtil().setHeight(80),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().radius(15)),
                              color: ColorPalette.lightGrey,
                            ),
                            child: RangeSlider(
                              values: RangeValues(
                                  minPrice!.toDouble(), maxPrice!.toDouble()),
                              min: getMinPrice()!.toDouble(),
                              max: getMaxPrice()!.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  minPrice = value.start.toInt();
                                  maxPrice = value.end.toInt();
                                });
                              },
                              activeColor: ColorPalette.darkBlue,
                              inactiveColor: ColorPalette.grey,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    if(categoriesList.length>1||categoriesList.length==1&&categoryHasSizes(categoriesList.first))
                    Text(
                        '${categoriesList.length != 1 ? 'Categories & ' : ''}Sizes',
                        style: Theme.of(context).textTheme.headline5),
                    Column(
                      children: List.generate(
                        categoriesList.length,
                        (externalIndex) {
                          List sizes = getSizes(categoriesList[externalIndex]);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (categoriesList.length != 1)
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(15)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${getCategoryName(categoriesList[externalIndex])}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(color: Colors.black)),
                                      Switch(
                                        value: selectedCategory[externalIndex],
                                        onChanged: (value) {
                                          setState.call(() {
                                            selectedCategory[externalIndex] =
                                                value;
                                          });
                                        },
                                        activeColor: ColorPalette.darkBlue,
                                      ),
                                    ],
                                  ),
                                ),
                              if (selectedCategory[externalIndex] &&
                                  sizes.length != 0)
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(20)),
                                  child: Wrap(
                                    children:
                                        List.generate(sizes.length, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (selectedSizes[externalIndex]
                                                .contains(sizes[index])) {
                                              selectedSizes[externalIndex]
                                                  .remove(sizes[index]);
                                            } else {
                                              selectedSizes[externalIndex]
                                                  .add(sizes[index]);
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: SizeCard(
                                            size: sizes[index],
                                            isSelected: selectedSizes.length ==
                                                    0
                                                ? false
                                                : selectedSizes[externalIndex]
                                                    .contains(sizes[index]),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black),
                  ),
                ),
                // ignore: deprecated_member_use
                RaisedButton(
                  onPressed: () {
                    print('Pressed');
                    filterProducts();
                    print("pop");
                    Navigator.pop(context);
                  },

                  child: Text(
                    'Apply',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black),
                  ),
                )
              ],
            );
          });
        });
  }

  void filterProducts() {
    bool minAmountCondition = minPrice != null && minPrice != 0;

    bool maxAmountCondition = maxPrice != null && maxPrice != 0;

    bool discountCondition = discount != null && discount != 0;

    filteredProducts.clear();
    print('In filterProducts');
    print(widget.products.length);
    for (int i = 0; i < widget.products.length; i++) {
      Product product = widget.products[i];
      bool condition = true;
      print(selectedCategory);
      print("Product category : ${product.productCategory}");
      print('In loop');

      for(int i=0; i<categoriesList.length; i++) {
        if(categoriesList[i]==product.productCategory) {
          condition = selectedCategory[i];
        }
      }
      if (condition && minAmountCondition) {
        print(
            "product price : ${product.productPrice} and min Price $minPrice");
        condition = product.productPrice >= minPrice!;
        print("First condition $condition");
      }
      if (condition && maxAmountCondition) {
        condition = product.productPrice <= maxPrice!;
        print("Second condition $condition");
      }
      if (condition && discountCondition) {
        int offer = (product.productPrice *
                100 /
                (product.productMrp ?? product.productPrice))
            .roundToDouble()
            .toInt();
        condition = (100 - offer) >= discount!;
        print("Third condition $condition");
      }

      for (int i = 0; i < selectedSizes.length; i++) {
        for (int j = 0;
            j < selectedSizes[i].length &&
                product.productCategory == categoriesList[i];
            j++) {
          if (condition &&
              product.productSizes != null &&
              product.productSizes!.length != 0) {
            condition = product.productSizes!.contains(selectedSizes[i][j]);
            print(
                "Product size : ${product.productSizes} selected Size : ${selectedSizes[i][j]} : Condition $condition");
            if (condition) {
              break;
            }
          }
        }
      }
      if (condition) {
        filteredProducts.add(product);
      }
    }
    switch (sortBy) {
      case "Price : Low to High":
        sortLowToHigh();
        break;
      case "Price : High to Low":
        sortHighToLow();
        break;
      case "New Arrivals":
        // if (widget.title == "New Arrival") break;
        // filteredProducts.reversed;
      newArrivals();
        break;
      default:
        break;
    }
    setState(() {});
  }
  newArrivals() {
    filteredProducts.sort((Product a,Product b)=>b.productCreatedOn.compareTo(a.productCreatedOn));
  }

  sortLowToHigh() {
    filteredProducts.sort(
        (Product a, Product b) => a.productPrice.compareTo(b.productPrice));
  }

  sortHighToLow() {
    filteredProducts.sort(
        (Product a, Product b) => b.productPrice.compareTo(a.productPrice));
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
          title: Text(widget.title,
              style: Theme.of(context).appBarTheme.textTheme!.headline1),
          actions: [
            IconButton(
                onPressed: () {
                  filterItemsDialog();
                },
                icon: Icon(CupertinoIcons.sort_down)),
            SizedBox(
              width: 15,
            )
          ],
          centerTitle: true,
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              await widget.onDrawerClick!();
            }
            return false;
          },
          child: filteredProducts.isEmpty
              ? widget.title == "Liked Products" && widget.products.isEmpty
                  ? Container(
                      height: ScreenUtil().setHeight(700),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/heart.png',
                            width: ScreenUtil().setWidth(170),
                            height: ScreenUtil().setHeight(170),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('No liked products found',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 26.sp)),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Looks like you haven’t like any products',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6)
                        ],
                      ),
                    )
                  : Container(
                      height: ScreenUtil().setHeight(700),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/frown.png',
                            width: ScreenUtil().setWidth(170),
                            height: ScreenUtil().setHeight(170),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('No products found',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 26.sp)),
                        ],
                      ),
                    )
              : GridView.builder(
                  itemCount: filteredProducts.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      childAspectRatio: 0.64),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemDetails(
                                    filteredProducts[index],
                                    heroTag: filteredProducts[index].productId +
                                        index.toString()))).then((value) => setState((){}));
                      },
                      child: ProductCard(
                        filteredProducts[index],
                        heroTag: filteredProducts[index].productId +
                            index.toString(),
                        showOff: showDiscountTag,
                      ),
                    );
                  },
                ),
        ));
  }
}
