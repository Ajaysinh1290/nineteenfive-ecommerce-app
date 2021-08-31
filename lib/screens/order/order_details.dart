import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/models/address.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/cancel_order.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/return_order.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/track_order.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/item_order_card.dart';
import 'package:time_machine/time_machine.dart';

class OrderDetails extends StatefulWidget {
  final Order order;

  OrderDetails(this.order);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late Address address;
  late Product product;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProduct();
    // StaticData.userData.addresses!.forEach((address) {
    //   String addressId;
    //   if (widget.order.productReturn != null) {
    //     addressId = widget.order.productReturn!.pickUpAddressId!;
    //   } else {
    //     addressId = widget.order.addressId!;
    //   }
    //   if (address.addressId == addressId) {
    //     this.address = address;
    //     return;
    //   }
    // });
    if (widget.order.productReturn != null) {
      address = widget.order.productReturn!.pickUpAddress!;
    } else {
      address = widget.order.address!;
    }
  }

  canReturnable() {
    if (widget.order.returnTime == null || widget.order.deliveryTime == null) {
      return false;
    }
    int timeDuration = int.parse(
        widget.order.returnTime!.substring(0, widget.order.returnTime!.indexOf(" ")));
    String timeLabel =
    widget.order.returnTime!.substring(widget.order.returnTime!.indexOf(" "));
    // if (product.returnTime == null || widget.order.deliveryTime == null) {
    //   return false;
    // }
    // int timeDuration = int.parse(
    //     product.returnTime!.substring(0, product.returnTime!.indexOf(" ")));
    // String timeLabel =
    //     product.returnTime!.substring(product.returnTime!.indexOf(" "));

    if (timeLabel.contains("Day")) {
      int diffInDays = DateTime.now()
          .difference(
              widget.order.deliveryTime!.add(Duration(days: timeDuration)))
          .inDays;
      return (diffInDays <= 0);
    } else if (timeLabel.contains("Month")) {
      LocalDate deliveryDate =
          LocalDate.dateTime(widget.order.deliveryTime ?? DateTime.now());
      LocalDate todayDate = LocalDate.dateTime(DateTime.now());
      int diffInMonths = todayDate.periodSince(deliveryDate).months +
          todayDate.periodSince(deliveryDate).years * 12;

      return diffInMonths < timeDuration;
    } else if (timeLabel.contains("Year")) {
      LocalDate deliveryDate =
          LocalDate.dateTime(widget.order.deliveryTime ?? DateTime.now());
      LocalDate todayDate = LocalDate.dateTime(DateTime.now());
      int diffInYears = todayDate.periodSince(deliveryDate).years;
      print("diff in years $diffInYears");
      return diffInYears < timeDuration;
    }
  }

  fetchProduct() {
    StaticData.products.forEach((element) {
      if (element.productId == widget.order.productId) {
        product = element;
      }
    });
  }

  getAccountNumber(String accountNumber) {
    String hiddenAccountNumber = "";

    for (int i = 0; i < accountNumber.length; i++) {
      if (i < accountNumber.length - 4) {
        hiddenAccountNumber += "*";
      } else {
        hiddenAccountNumber += accountNumber[i];
      }
    }
    return hiddenAccountNumber;
  }

  @override
  Widget build(BuildContext context) {
    // DateTime deliveryDate = DateFormat("dd-MM-yyyy").parse("10-02-2020");
    // DateTime todayDate = DateFormat("dd-MM-yyyy").parse("12-02-2021");
    //
    // // print(todayDate.difference(deliveryDate).inDays);

    print("Can Returnable : ${canReturnable()}");
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
        title: Text(
          'Order Details',
          style: Theme.of(context).appBarTheme.textTheme!.headline1,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(28), horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemOrderCard(widget.order),
              SizedBox(
                height: 15,
              ),
              Text('Order Details',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                      letterSpacing: 1.2)),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order date',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 22.sp)),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Flexible(
                    child: Text(
                      Constants.onlyDateFormat
                          .format(widget.order.orderTime ?? DateTime.now()),
                      style: GoogleFonts.openSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.darkGrey,
                          letterSpacing: 1),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 1.5,
                color: ColorPalette.lightGrey,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order id',
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Flexible(
                    child: Text(
                      widget.order.orderId,
                      style: GoogleFonts.openSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.darkGrey,
                          letterSpacing: 1),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 1.5,
                color: ColorPalette.lightGrey,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sub total',
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Flexible(
                    child: Text(
                      Constants.currencySymbol +
                          widget.order.totalAmount.toString(),
                      style: GoogleFonts.openSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.darkGrey,
                          letterSpacing: 1),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 1.5,
                color: ColorPalette.lightGrey,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipping',
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Flexible(
                    child: Text(
                      Constants.currencySymbol +
                          widget.order.shippingCharge.toString(),
                      style: GoogleFonts.openSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.darkGrey,
                          letterSpacing: 1),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 1.5,
                color: ColorPalette.lightGrey,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Flexible(
                    child: Text(
                      Constants.currencySymbol +
                          (widget.order.totalAmount+widget.order.shippingCharge!).toString(),
                      style: GoogleFonts.openSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.darkGrey,
                          letterSpacing: 1),
                    ),
                  )
                ],
              ),
              if (widget.order.promoCodeDiscount != null)
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 1.5,
                      color: ColorPalette.lightGrey,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Promo code discount',
                            style: Theme.of(context).textTheme.headline3),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Flexible(
                          child: Text(
                            "-" +
                                Constants.currencySymbol +
                                widget.order.promoCodeDiscount.toString(),
                            style: GoogleFonts.openSans(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorPalette.darkGrey,
                                letterSpacing: 1),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 1.5,
                      color: ColorPalette.lightGrey,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Grand total',
                            style: Theme.of(context).textTheme.headline3),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Flexible(
                          child: Text(
                            Constants.currencySymbol +
                                (widget.order.totalAmount +
                                        widget.order.shippingCharge! -
                                        widget.order.promoCodeDiscount!)
                                    .toString(),
                            style: GoogleFonts.openSans(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorPalette.darkGrey,
                                letterSpacing: 1),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 1.5,
                color: ColorPalette.lightGrey,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Transaction id',
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Flexible(
                    child: Text(
                      widget.order.transactionId ?? '',
                      style: GoogleFonts.openSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.darkGrey,
                          letterSpacing: 1),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 1.5,
                color: ColorPalette.lightGrey,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order status',
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Flexible(
                    child: Text(
                      widget.order.productReturn != null &&
                              widget.order.productReturn!.productPickupTime !=
                                  null
                          ? "Returned"
                          : widget.order.productCancel != null
                              ? "Cancelled"
                              : widget.order.deliveryTime != null
                                  ? 'Delivered'
                                  : widget.order.outForDeliveryTime != null
                                      ? "Out for delivery"
                                      : widget.order.shippingTime != null
                                          ? "Shipped"
                                          : "Confirmed",
                      style: GoogleFonts.openSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.darkGrey,
                          letterSpacing: 1),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(35),
              ),
              widget.order.productCancel != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Refund Status',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.sp,
                                    letterSpacing: 1.2)),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          widget.order.productCancel!.refundTime != null
                              ? "Money successfully refunded to your bank account ${getAccountNumber(widget.order.productCancel!.bankDetails!.accountNumber)} on " +
                                  Constants.onlyDateFormat.format(
                                      widget.order.orderTime ??
                                          DateTime.now()) +
                                  "."
                              : "We will refund your money soon on ${getAccountNumber(widget.order.productCancel!.bankDetails!.accountNumber)} account number.",
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    )
                  : widget.order.productReturn != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            Text('PickUp Address',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
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
                              height: ScreenUtil().setHeight(40),
                            ),
                            Text('Refund Status',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.sp,
                                        letterSpacing: 1.2)),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            Text(
                              widget.order.productReturn!.refundTime != null
                                  ? "Money successfully refunded to your bank account ${getAccountNumber(widget.order.productReturn!.bankDetails!.accountNumber)} on " +
                                      Constants.onlyDateFormat.format(
                                          widget.order.orderTime ??
                                              DateTime.now()) +
                                      "."
                                  : "We will refund your money soon on ${getAccountNumber(widget.order.productReturn!.bankDetails!.accountNumber)} account number.",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(50),
                            ),
                            LongBlueButton(
                              text: 'Track Return Status',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TrackOrder(widget.order)));
                              },
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Shipping Address',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
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
                              height: ScreenUtil().setHeight(40),
                            ),
                            LongBlueButton(
                              text: 'Track Order Status',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TrackOrder(widget.order)));
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            if (widget.order.shippingTime == null)
                              LongBlueButton(
                                text: 'Cancel Order',
                                color: ColorPalette.lightGrey,
                                onPressed: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CancelOrder(widget.order)))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                              ),
                            if (widget.order.deliveryTime != null &&
                                canReturnable())
                              LongBlueButton(
                                text: 'Return Product',
                                color: ColorPalette.lightGrey,
                                onPressed: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReturnOrder(widget.order)))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                              ),
                          ],
                        )
            ],
          )),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(20.0),
      //   child: LongBlueButton(
      //     text: 'Track Order Status',
      //     onPressed: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => TrackOrder(widget.order)));
      //     },
      //   ),
      // ),
    );
  }
}
