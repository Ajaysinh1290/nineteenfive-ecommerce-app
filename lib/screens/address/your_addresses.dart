import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/screens/address/address_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/payment/bank_details_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/payment/razorpay_payment_screen.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/address_card.dart';

class YourAddresses extends StatefulWidget {
  final List<Order>? orders;
  final Function? onDrawerClick;
  final bool? isFromCart;
  final Order? order;
  ProductReturn? productReturn;

  YourAddresses(
      {this.orders,
      this.onDrawerClick,
      this.isFromCart,
      this.order,
      this.productReturn});

  @override
  _YourAddressesState createState() => _YourAddressesState();
}

class _YourAddressesState extends State<YourAddresses> {
  late int selectedAddress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedAddress = -1;
    if (widget.orders != null ||
        widget.productReturn != null && widget.order != null) {
      selectedAddress = 0;
    }
  }

  pushNewScreen() {
    Future.delayed(Duration(microseconds: 1)).then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddressScreen.addAddress())).then((value) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xfff3f3f3),
      appBar: AppBar(
        backgroundColor: Color(0xfff3f3f3),
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
        title: Text(
            widget.orders != null
                ? 'Select Address'
                : widget.productReturn != null
                    ? "Select Pickup Address"
                    : 'Your Addresses',
            style: Theme.of(context).appBarTheme.textTheme!.headline1!.copyWith(
                fontSize: widget.productReturn != null ? 24.sp : 25.sp)),
        actions: [
          IconButton(
            onPressed: () {
              // if (widget.orders != null) {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) =>
              //               AddressScreen(widget.orders, widget.isFromCart)));
              // }
              // else if(widget.productReturn!=null&&widget.order!=null) {
              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressScreen.returnOrder(widget.order, widget.productReturn)));
              // }
              // else {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressScreen.addAddress()))
                  .then((value) {
                setState(() {});
              });
              // }
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: ScreenUtil().setWidth(30),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(20),
          )
        ],
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            widget.onDrawerClick!();
          }
          return false;
        },
        child: StaticData.userData.addresses!.isEmpty
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddressScreen.addAddress()))
                      .then((value) {
                    setState(() {});
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(700),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/plus-circle.png',
                        width: ScreenUtil().setWidth(170),
                        height: ScreenUtil().setHeight(170),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Add Address',
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 26.sp)),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.only(
                    left: 28,
                    right: 28,
                    bottom: widget.orders == null ? 28.sp : 128.sp,
                    top: 28.sp),
                itemCount: StaticData.userData.addresses!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: widget.orders != null ||
                              widget.productReturn != null &&
                                  widget.order != null
                          ? () {
                              setState(() {
                                selectedAddress = index;
                              });
                            }
                          : null,
                      child: Dismissible(
                        key: Key(StaticData.userData.addresses![index].addressId),
                        onDismissed: (direction) async {
                          StaticData.userData.addresses!.removeAt(index);
                          await FirebaseDatabase.storeUserData(
                              StaticData.userData);
                          if (selectedAddress != 0) {
                            selectedAddress--;
                          }
                          setState(() {});
                        },
                        child: AddressCard(
                          StaticData.userData.addresses![index],
                          index == selectedAddress,
                          onDeleted: () async {
                            StaticData.userData.addresses!.removeAt(index);
                            if (selectedAddress != 0) {
                              selectedAddress--;
                            }
                            await FirebaseDatabase.storeUserData(
                                StaticData.userData);
                            setState(() {});
                          },
                        ),
                      ));
                },
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: (widget.orders != null ||
                  widget.productReturn != null && widget.order != null) &&
          StaticData.userData.addresses!.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: LongBlueButton(
                text: 'Proceed',
                onPressed: () {
                  if (widget.orders != null) {
                    widget.orders!.forEach((element) {
                      element.address = StaticData.userData.addresses![selectedAddress];
                    });
                    // Navigator.push(
                    //     context,
                    //     CustomPageRoute(
                    //         widget: PaymentSuccessful(
                    //             widget.orders!, widget.isFromCart!),
                    //         alignment: Alignment.center,
                    //         curve: Curves.elasticOut,
                    //         duration: Duration(seconds: 1)));
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RazorPayPaymentScreen(widget.orders!,widget.isFromCart)));
                  } else {
                    widget.productReturn!.pickUpAddress= StaticData.userData.addresses![selectedAddress];
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BankDetailsScreen.returnOrder(
                                widget.order!, widget.productReturn)));
                  }
                },
              ),
            )
          : null,
    );
  }
}
