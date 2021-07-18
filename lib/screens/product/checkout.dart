import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/address/address_screen.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/screens/address/your_addresses.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/item_checkout_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/route/CustomPageRoute.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class Checkout extends StatefulWidget {
  final Product product;

  const Checkout(this.product);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int shippingPrice = 40;
  late int numberOfItems;

  String? size;

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
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.product.productSizes!.isNotEmpty) {
      size = widget.product.productSizes!.first;
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setHeight(15),
                      ),
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(70),
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),
                            top: 10,
                            bottom: 5,
                            right: ScreenUtil().setWidth(20)),
                        decoration: BoxDecoration(
                            color: ColorPalette.lightGrey,
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().radius(15))),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.disabled,
                                cursorColor: Theme.of(context).cursorColor,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Promocode',
                                    hintStyle:
                                        Theme.of(context).textTheme.headline6),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: ColorPalette.black),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            LongBlueButton(
                              width: 86,
                              height: 50,
                              text: 'Apply',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                              borderRadius: 10,
                              onPressed: () {},
                            )
                          ],
                        ),
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
                            Constants.currencySymbol + getTotal().toString(),
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
                            Constants.currencySymbol + shippingPrice.toString(),
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
                                (shippingPrice + getTotal()).toString(),
                            style: GoogleFonts.openSans(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(100),
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
