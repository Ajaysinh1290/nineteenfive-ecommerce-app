import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/models/poster.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/cart/cart_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/product/products.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/search_screen.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/product_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';
import '../../utils/data/static_data.dart';
import '../product/item_details.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final Function onDrawerClick;

  HomeScreen({required this.onDrawerClick});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int categoryIndex = 0;
  String categoryId = "";

  PageController posterPageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  String? getUserName() {
    if (MyFirebaseAuth.firebaseAuth.currentUser == null) {
      return "Friend";
    }
    return (StaticData.userData.userName.contains(" ")
        ? MyFirebaseAuth.firebaseAuth.currentUser!.displayName!.substring(0,
            MyFirebaseAuth.firebaseAuth.currentUser!.displayName!.indexOf(" "))
        : MyFirebaseAuth.firebaseAuth.currentUser!.displayName);
  }

  getFilteredProducts(Poster poster) {
    List<Product> products = [];

    bool minAmountCondition = poster.minAmount != null && poster.minAmount != 0;

    bool maxAmountCondition = poster.maxAmount != null && poster.maxAmount != 0;

    bool minOffCondition = poster.minOff != null && poster.minOff != 0;

    bool maxOffCondition = poster.maxOff != null && poster.maxOff != 0;

    for (int i = 0; i < StaticData.products.length; i++) {
      Product product = StaticData.products[i];
      if (product.productCategory == poster.categoryId) {
        bool condition = true;

        if (minAmountCondition) {
          condition = product.productPrice >= poster.minAmount!;
        }
        if (condition && maxAmountCondition) {
          condition = product.productPrice <= poster.maxAmount!;
        }
        if (condition && minOffCondition) {
          int offer = (product.productPrice *
                  100 /
                  (product.productMrp ?? product.productPrice))
              .roundToDouble()
              .toInt();
          condition = (100 - offer) >= poster.minOff!;
        }
        if (condition && maxOffCondition) {
          int offer = (product.productPrice *
                  100 /
                  (product.productMrp ?? product.productPrice))
              .roundToDouble()
              .toInt();
          condition = (100 - offer) <= poster.maxOff!;
        }
        if (condition) {
          products.add(product);
        }
      }
    }
    return products;
  }

  getCategoryName(String categoryId) {
    for (int i = 0; i < StaticData.categoriesList.length; i++) {
      if (StaticData.categoriesList[i].categoryId == categoryId) {
        return StaticData.categoriesList[i].categoryName;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    posterPageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => widget.onDrawerClick.call(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: Container(
                  height: ScreenUtil().setWidth(42),
                  width: ScreenUtil().setWidth(42),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: MyFirebaseAuth.firebaseAuth.currentUser != null &&
                          MyFirebaseAuth.firebaseAuth.currentUser!.photoURL !=
                              null
                      ? ClipOval(
                          child: ImageNetwork(
                          imageUrl: MyFirebaseAuth
                                  .firebaseAuth.currentUser!.photoURL ??
                              '',
                          errorIcon: CupertinoIcons.person_fill,
                          fit: BoxFit.cover,
                        ))
                      : Icon(
                          CupertinoIcons.person_fill,
                          size: ScreenUtil().setWidth(25),
                          color: ColorPalette.darkGrey,
                        ),
                ),
              ),
            ),
            Text(
              'Hi, ' + (getUserName() ?? '') + " !",
              style: Theme.of(context).appBarTheme.textTheme!.headline1,
            )
          ],
        ),
        actions: [

          GestureDetector(
              onTap: () {
                Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => CartScreen()))
                    .then((value) {
                  setState(() {});
                });
              },
              child: Container(
                  height: ScreenUtil().setWidth(30),
                  width: ScreenUtil().setWidth(30),
                  child: Image.asset(StaticData.userData.cart == null ||
                          StaticData.userData.cart!.isEmpty
                      ? "assets/icons/shopping_cart.png"
                      : 'assets/icons/shopping_cart_with_red_dot.png'))),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(28),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen()))
                  .then((value) => setState(() {}));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
                  color: ColorPalette.lightGrey),
              margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(28),
                right: ScreenUtil().setWidth(28),
              ),
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setWidth(20),
                horizontal: ScreenUtil().setWidth(20),
              ),
              child: Row(
                children: [
                  // Image.asset(
                  //   'assets/icons/search.png',
                  // ),
                  Icon(
                    CupertinoIcons.search,
                    color: ColorPalette.darkGrey,
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Text('Search Product',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: ColorPalette.darkGrey))
                ],
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posters')
                .where("position", isEqualTo: "Top")
                .where("is_active", isEqualTo: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Poster> topPosters = [];
              if (snapshot.hasData) {
                List data = snapshot.data.docs;
                data.forEach((element) =>
                    topPosters.add(Poster.fromJson(element.data())));
              }
              return SizedBox(
                height: ScreenUtil().setWidth(210),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: posterPageController,
                      itemCount: topPosters.length,
                      onPageChanged: (index) {
                        setState(() {});
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => Products(
                                            products: getFilteredProducts(
                                                topPosters[index]),
                                            title: getCategoryName(
                                                topPosters[index].categoryId))))
                                .then((value) => setState(() {}));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ImageNetwork(
                                  imageUrl: topPosters[index].imageUrl,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 8,
                        width: 125,
                        margin: EdgeInsets.only(bottom: 15),
                        child: Center(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: topPosters.length,
                            itemBuilder: (context, index) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.linear,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: index ==
                                          posterPageController.page!
                                              .roundToDouble()
                                      ? ColorPalette.lightGrey
                                      : ColorPalette.white.withOpacity(0.3),
                                ),
                                width: 8,
                                height: 8,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('products')
                .orderBy('product_created_on', descending: true)
                .limit(15)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Product> newArrivals = [];
              if (snapshot.hasData) {
                List data = snapshot.data.docs;
                data.forEach((element) {
                  Product product = Product.fromJson(element.data());
                  if (product.isActive) {
                    newArrivals.add(product);
                  }
                });
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('New Arrival',
                            style: Theme.of(context).textTheme.headline3),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Products(
                                          products: newArrivals,
                                          title: "New Arrival",
                                        ))).then((value) => setState(() {}));
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setWidth(150),
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(40)),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount:
                          newArrivals.length > 10 ? 10 : newArrivals.length,
                      itemBuilder: (context, index) {
                        Product product = newArrivals[index];
                        return Hero(
                          tag: product.productId +
                              "new_arrived" +
                              index.toString(),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ItemDetails(
                                            product,
                                            heroTag: product.productId +
                                                "new_arrived" +
                                                index.toString(),
                                          ))).then((value) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(130),
                              margin: EdgeInsets.only(
                                  right: 25, left: index == 0 ? 28 : 0),
                              decoration: BoxDecoration(
                                  color: ColorPalette.lightGrey,
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().radius(20))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().radius(20)),
                                child: ImageNetwork(
                                  imageUrl: product.productImages.first,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Categories',
                    style: Theme.of(context).textTheme.headline3),
              ],
            ),
          ),
          GridView.builder(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setWidth(40),
                horizontal: ScreenUtil().setWidth(20)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: StaticData.categoriesList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  List<Product> products = [];

                  StaticData.products.forEach((element) {
                    if (element.productCategory ==
                        StaticData.categoriesList[index].categoryId) {
                      products.add(element);
                    }
                  });
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Products(
                                products: products,
                                title: StaticData
                                    .categoriesList[index].categoryName,
                              ))).then((value) => setState(() {}));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100], shape: BoxShape.circle),
                      width: ScreenUtil().setWidth(130),
                      height: ScreenUtil().setWidth(130),
                      child: ClipOval(
                          child: ImageNetwork(
                        imageUrl: StaticData.categoriesList[index].imageUrl,
                        fit: BoxFit.cover,
                      )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(StaticData.categoriesList[index].categoryName)
                  ],
                ),
              );
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('products')
                .where("is_active", isEqualTo: true)
                .where("is_featured", isEqualTo: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Product> featuredProducts = [];
              if (snapshot.hasData) {
                List data = snapshot.data.docs;
                data.forEach((element) {
                  featuredProducts.add(Product.fromJson(element.data()));
                });
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Featured',
                            style: Theme.of(context).textTheme.headline3),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Products(
                                          products: featuredProducts,
                                          title: 'Featured',
                                        ))).then((value) => setState(() {}));
                          },
                        )
                      ],
                    ),
                  ),
                  GridView.builder(
                    itemCount: (featuredProducts.length > 8)
                        ? 8
                        : featuredProducts.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(18),
                      vertical: ScreenUtil().setWidth(40),
                    ),
                    physics: NeverScrollableScrollPhysics(),
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
                                      builder: (context) =>
                                          ItemDetails(featuredProducts[index])))
                              .then((value) => setState(() {}));
                        },
                        child: ProductCard(
                          featuredProducts[index],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posters')
                .where("position", isEqualTo: "Bottom")
                .where("is_active", isEqualTo: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Poster> bottomPosters = [];
              if (snapshot.hasData) {
                List data = snapshot.data.docs;
                data.forEach((element) =>
                    bottomPosters.add(Poster.fromJson(element.data())));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Essential For You',
                            style: Theme.of(context).textTheme.headline3),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: bottomPosters.length,
                    padding: EdgeInsets.all(20.0),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Products(
                                      products: getFilteredProducts(
                                          bottomPosters[index]),
                                      title: getCategoryName(
                                          bottomPosters[index]
                                              .categoryId)))).then((value) {
                            setState(() {});
                          });
                        },
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: ScreenUtil().setHeight(350)),
                          padding: const EdgeInsets.all(20.0),
                          child: ImageNetwork(
                            imageUrl: bottomPosters[index].imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
