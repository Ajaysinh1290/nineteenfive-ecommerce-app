import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/address/your_addresses.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/item_checkout_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/dialog/my_dialog.dart';

class Checkout extends StatefulWidget {
  final Product product;

  const Checkout(this.product);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late int numberOfItems;
  String? size;
  int? promoCodeDiscount;
  late List<dynamic> promoCodeUsed;

  int getTotal() {
    int total = 0;
    total += widget.product.productPrice * numberOfItems;
    return total;
  }

  Order getOrder() {
    print('in func $size');
    return Order(
        userId: MyFirebaseAuth.firebaseAuth.currentUser!.uid,
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        numberOfItems: numberOfItems,
        productId: widget.product.productId,
        productSize: size,
        totalAmount: getTotal(),
        shippingCharge:
            widget.product.shippingCharge ?? StaticData.shippingCharge,
        promoCodeDiscount: promoCodeDiscount,
        promoCode: promoCodeUsed.first,
        returnTime: widget.product.returnTime);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.product.productSizes!.isNotEmpty) {
      size = widget.product.productSizes!.first;
    }
    promoCodeUsed = [null];

    if (StaticData.userData.promoCodesUsed != null) {
      promoCodeUsed += StaticData.userData.promoCodesUsed!;
    }
    numberOfItems = 1;
  }

  void onNumberOfItemsChanged(numberOfItem) {
    setState(() {
      numberOfItems = numberOfItem;
    });
  }

  void onSizeChanged(size) {
    this.size = size;
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
          title: Text('Checkout',
              style: Theme.of(context).appBarTheme.textTheme!.headline1),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            child: Column(
              children: [
                ItemCheckoutCard(
                  product: widget.product,
                  numberOfItems: numberOfItems,
                  selectedSize: size,
                  onNumberOfItemsChanged: onNumberOfItemsChanged,
                  onSizeChanged: onSizeChanged,
                  promoCodeName: promoCodeUsed.first,
                  promoCodesUsed: promoCodeUsed,
                  promoCodeDiscount: (promoCodeName, discount) {
                    if (discount != null) {
                      if (promoCodeDiscount == null) {
                        promoCodeDiscount = 0;
                      }
                      promoCodeUsed.first = promoCodeName;
                      promoCodeDiscount = promoCodeDiscount! + discount;
                    } else if (promoCodeDiscount != null &&
                        promoCodeUsed.first != null) {
                      StaticData.promoCodes.forEach((promoCode) {
                        if (promoCode.promoCode == promoCodeUsed.first) {
                          promoCodeDiscount =
                              promoCodeDiscount! - promoCode.discount;
                        }
                      });

                      if (promoCodeDiscount == 0) {
                        promoCodeDiscount = null;
                      }
                      promoCodeUsed.first = promoCodeName;
                    }
                    setState(() {});
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
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
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              Constants.currencySymbol + getTotal().toString(),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipping',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              Constants.currencySymbol +
                                  (widget.product.shippingCharge ??
                                          StaticData.shippingCharge)
                                      .toString(),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              Constants.currencySymbol +
                                  ((widget.product.shippingCharge ??
                                              StaticData.shippingCharge) +
                                          getTotal())
                                      .toString(),
                              style: GoogleFonts.openSans(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0),
                            ),
                          ),
                        ],
                      ),
                      if (promoCodeDiscount != null)
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Promo code discount',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    "- " +
                                        Constants.currencySymbol +
                                        promoCodeDiscount.toString(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Grand Total',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    Constants.currencySymbol +
                                        (getTotal() +
                                                (widget.product
                                                        .shippingCharge ??
                                                    StaticData.shippingCharge) -
                                                promoCodeDiscount!)
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
                        )
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(140),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LongBlueButton(
            onPressed: () {
              List<Order> orders = [];
              orders.add(getOrder());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => YourAddresses(
                            orders: orders,
                            isFromCart: false,
                          )));
            },
            text: 'Checkout',
          ),
        ));
  }
}
