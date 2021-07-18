import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/models/address.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/screens/payment/api_key.dart';
import 'package:nineteenfive_ecommerce_app/screens/payment/payment_successfull.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/item_order_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_ecommerce_app/widgets/route/CustomPageRoute.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../utils/data/static_data.dart';

class RazorPayPaymentScreen extends StatefulWidget {
  List<Order> orders;
  bool? isFromCart;

  RazorPayPaymentScreen(this.orders, this.isFromCart);

  @override
  _RazorPayPaymentScreenState createState() => _RazorPayPaymentScreenState();
}

class _RazorPayPaymentScreenState extends State<RazorPayPaymentScreen> {
  late Razorpay razorPay;

  late Address address;

  int shippingPrice = 40;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    razorPay = new Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    address = widget.orders.first.address!;
    // fetchAddress();
  }

  // void fetchAddress() {
  //   StaticData.userData.addresses!.forEach((address) {
  //     if (address.addressId == widget.orders.first.addressId!) {
  //       this.address = address;
  //       return;
  //     }
  //   });
  // }

  int getTotal() {
    int total = 0;
    widget.orders.forEach((element) {
      total += element.totalAmount;
    });
    return total;
  }

  getProductName() {
    String productName = '';
    widget.orders.forEach((element) {
      productName += fetchProductName(element.productId) + ",";
    });
    return productName.substring(0, productName.length - 1);
  }

  String fetchProductName(productId) {
    String productName = '';
    StaticData.products.forEach((element) {
      if (element.productId == productId) {
        productName = element.productName;
      }
    });
    return productName;
  }

  storeData(paymentId) async {
    widget.orders.forEach((element) {});
    widget.orders.forEach((order) async {
      order.orderTime = DateTime.now();
      order.transactionId = paymentId;
      await FirebaseDatabase.storeOrder(order, true);
    });
    if (widget.isFromCart != null && widget.isFromCart!) {
      StaticData.userData.cart!.clear();
      await FirebaseDatabase.storeUserData(StaticData.userData);
    }
  }

  void openCheckout() {
    var options = {
      "key": RAZOR_PAY_API_KEY,
      "amount": (getTotal()+shippingPrice )* 100,
      "name": "Nineteenfive",
      "description": getProductName(),
      "prefill": {
        "contact": address.mobileNumber,
        "email": StaticData.userData.email
      },
      'external': {
        'wallets': ['paytm']
      },
    };
    try {
      razorPay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Success');
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text("Payment Success")));

    storeData(response.paymentId);

    print("Order id : ${response.orderId}");
    print("Payment id : ${response.paymentId}");
    print("Signature : ${response.signature}");

    Navigator.push(
        context,
        CustomPageRoute(
            widget: PaymentSuccessful(widget.orders),
            alignment: Alignment.center,
            curve: Curves.elasticOut,
            duration: Duration(seconds: 1)));
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    print('Error');

    String errorMessage = '';
    switch(response.code) {
      case Razorpay.NETWORK_ERROR : errorMessage = "Network Error..!"; break;
      case Razorpay.INVALID_OPTIONS : errorMessage = "Something went wrong...!"; break;
      case Razorpay.PAYMENT_CANCELLED : errorMessage = "Payment Cancelled..!"; break;
      case Razorpay.TLS_ERROR : errorMessage = "Device does not support TLS v1.1 or TLS v1.2"; break;
      default : errorMessage = "Unknown Error"; break;
    }
    MyDialog.showMyDialog(context, errorMessage);
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    print('External Wallet');
    MyDialog.showMyDialog(context, "External Wallet");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorPay.clear();
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
        title: Text('Payment',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(28), horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.orders.length,
                itemBuilder: (context, index) {
                  return ItemOrderCard(widget.orders[index]);
                },
              ),
              SizedBox(
                height: 15,
              ),
              Text('Order Details',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                      letterSpacing: 1.2)),
              SizedBox(
                height: ScreenUtil().setHeight(30),
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
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shipping Address',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                          letterSpacing: 1.2)),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Text(
                      address.name +
                          "\n" +
                          address.houseNoOrFlatNoOrFloor +
                          " " +
                          address.societyOrStreetName +
                          "\n" +
                          address.landMark +
                          "\n" +
                          address.area +
                          " " +
                          address.city +
                          "\n" +
                          address.state +
                          ", " +
                          address.pinCode,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: ColorPalette.darkGrey)),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                ],
              )
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LongBlueButton(
          onPressed: openCheckout,
          text: 'Proceed To Pay',
        ),
      ),
    );
  }
}
