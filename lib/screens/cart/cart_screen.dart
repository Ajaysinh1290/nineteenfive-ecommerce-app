import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/main_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/address/your_addresses.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/item_checkout_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class CartScreen extends StatefulWidget {
  const CartScreen();

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> products = [];
  late List<int?> promoCodeDiscount;
  late List<dynamic> promoCodeUsed;

  int getTotal() {
    num total = 0;
    for (int i = 0; i < products.length; i++) {
      total +=
          products[i].productPrice * StaticData.userData.cart![i].numberOfItems;
    }
    return total.toInt();
  }

  Order getOrder(int index) {
    return Order(
        userId: MyFirebaseAuth.firebaseAuth.currentUser!.uid,
        orderId: (DateTime.now().millisecondsSinceEpoch + index).toString(),
        numberOfItems: StaticData.userData.cart![index].numberOfItems,
        productId: products[index].productId,
        productSize: StaticData.userData.cart![index].productSize,
        totalAmount: products[index].productPrice *
            StaticData.userData.cart![index].numberOfItems,
        promoCodeDiscount: promoCodeDiscount[index],
        promoCode: promoCodeUsed[index],
        shippingCharge:
            products[index].shippingCharge ?? StaticData.shippingCharge,
        returnTime: products[index].returnTime);
  }

  num getShippingCharge() {
    num shippingCharge = 0;
    products.forEach((element) {
      shippingCharge += element.shippingCharge ?? StaticData.shippingCharge;
    });
    return shippingCharge;
  }

  int? getPromoCodeTotals() {
    int? discount;
    promoCodeDiscount.forEach((element) {
      if (element != null) {
        if (discount == null) discount = 0;
        discount = discount! + element;
      }
    });
    return discount;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    promoCodeUsed = [];
    promoCodeDiscount = [];
    StaticData.userData.cart!.forEach((cart) {
      StaticData.products.forEach((product) {
        if (cart.productId == product.productId) {
          products.add(product);
          promoCodeUsed.add(null);
          promoCodeDiscount.add(null);
        }
      });
    });
    if (StaticData.userData.promoCodesUsed != null) {
      promoCodeUsed += StaticData.userData.promoCodesUsed!;
    }
  }

  Future<void> onItemDeleted(int index) async {
    StaticData.userData.cart!.removeAt(index);
    await FirebaseDatabase.storeUserData(StaticData.userData);
    setState(() {
      products.removeAt(index);
    });
  }

  Future<void> onNumberOfItemsChanged(numberOfItem, index) async {
    StaticData.userData.cart![index].numberOfItems = numberOfItem;
    await FirebaseDatabase.storeUserData(StaticData.userData);

    setState(() {});
  }

  Future<void> onSizeChanged(size, index) async {
    StaticData.userData.cart![index].productSize = size;
    await FirebaseDatabase.storeUserData(StaticData.userData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding UI IN Cart");
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
          title: Text('Cart',
              style: Theme.of(context).appBarTheme.textTheme!.headline1),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            child: Column(
              children: [
                StaticData.userData.cart == null ||
                        StaticData.userData.cart!.isEmpty
                    ? Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height - 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/shopping-cart-big.png',
                              width: ScreenUtil().setWidth(170),
                              height: ScreenUtil().setHeight(170),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Your cart is empty',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(fontSize: 26.sp)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                'Looks like you haven\'t added anything to your cart yet',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6)
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  key: Key(DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString()),
                                  onDismissed: (_) => onItemDeleted(index),
                                  child: ItemCheckoutCard(
                                    enableAnimation: false,
                                    product: products[index],
                                    promoCodeName: promoCodeUsed[index],
                                    promoCodesUsed: promoCodeUsed,
                                    promoCodeDiscount:
                                        (promoCodeName, discount) {
                                      if (discount != null) {
                                        if (promoCodeDiscount[index] == null) {
                                          promoCodeDiscount[index] = 0;
                                        }
                                        promoCodeUsed[index] = promoCodeName;
                                        promoCodeDiscount[index] =
                                            promoCodeDiscount[index]! +
                                                discount;
                                      } else if (promoCodeDiscount[index] !=
                                              null &&
                                          promoCodeUsed[index] != null) {
                                        StaticData.promoCodes
                                            .forEach((promoCode) {
                                          if (promoCode.promoCode ==
                                              promoCodeUsed[index]) {
                                            promoCodeDiscount[index] =
                                                promoCodeDiscount[index]! -
                                                    promoCode.discount;
                                          }
                                        });

                                        if (promoCodeDiscount[index] == 0) {
                                          promoCodeDiscount[index] = null;
                                        }
                                        promoCodeUsed[index] = promoCodeName;
                                      }
                                      setState(() {});
                                    },
                                    onDeleted: () => onItemDeleted(index),
                                    onSizeChanged: (size) =>
                                        onSizeChanged(size, index),
                                    onNumberOfItemsChanged: (numberOfItem) =>
                                        onNumberOfItemsChanged(
                                            numberOfItem, index),
                                    selectedSize: StaticData
                                        .userData.cart![index].productSize,
                                    numberOfItems: StaticData
                                        .userData.cart![index].numberOfItems,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Text(
                                  Constants.currencySymbol +
                                      getTotal().toString(),
                                  style: GoogleFonts.openSans(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Container(
                              width: double.infinity,
                              height: 1.5,
                              color: ColorPalette.lightGrey,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Shipping',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Text(
                                  Constants.currencySymbol +
                                      getShippingCharge().toString(),
                                  style: GoogleFonts.openSans(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Container(
                              width: double.infinity,
                              height: 1.5,
                              color: ColorPalette.lightGrey,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Text(
                                  Constants.currencySymbol +
                                      (getShippingCharge() + getTotal())
                                          .toString(),
                                  style: GoogleFonts.openSans(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0),
                                ),
                              ],
                            ),
                            if (getPromoCodeTotals() != null)
                              Column(
                                children: [
                                  SizedBox(
                                    height: ScreenUtil().setHeight(20),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1.5,
                                    color: ColorPalette.lightGrey,
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(20),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Promo code discount',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "- " +
                                              Constants.currencySymbol +
                                              getPromoCodeTotals().toString(),
                                          style: GoogleFonts.openSans(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(20),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1.5,
                                    color: ColorPalette.lightGrey,
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(20),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Grand Total',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          Constants.currencySymbol +
                                              (getTotal() +
                                                      getShippingCharge() -
                                                      getPromoCodeTotals()!)
                                                  .toString(),
                                          style: GoogleFonts.openSans(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: ScreenUtil().setHeight(120),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LongBlueButton(
            onPressed: () {
              if (StaticData.userData.cart == null ||
                  StaticData.userData.cart!.isEmpty) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MainScreen()));
              } else {
                List<Order> orders = [];
                for (int i = 0; i < StaticData.userData.cart!.length; i++) {
                  orders.add(getOrder(i));
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => YourAddresses(
                              orders: orders,
                              isFromCart: true,
                            )));
              }
            },
            text: StaticData.userData.cart!.length == 0
                ? 'Start Shopping'
                : 'Buy ' +
                    StaticData.userData.cart!.length.toString() +
                    " Items",
          ),
        ));
  }
}
