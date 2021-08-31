import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/screens/payment/bank_details_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/address/your_addresses.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/item_order_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class ReturnOrder extends StatefulWidget {
  Order order;

  ReturnOrder(this.order);

  @override
  _ReturnOrderState createState() => _ReturnOrderState();
}

class _ReturnOrderState extends State<ReturnOrder> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController cancelReasonController = TextEditingController();
  int numberOfItems = 1;

  validate() {
    if (formKey.currentState!.validate()) {
      ProductReturn productReturn = ProductReturn(
        returnReason: cancelReasonController.text,
        numberOfItems: numberOfItems,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => YourAddresses(
                  order: widget.order, productReturn: productReturn)));
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
        title: Text('Return Order',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil()
              .setHeight(widget.order.numberOfItems > 1 ? 835 : 775),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setWidth(28), horizontal: 28),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ItemOrderCard(widget.order),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                if (widget.order.numberOfItems > 1)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Qty to Return"),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (numberOfItems > 1) {
                                  setState(() {
                                    numberOfItems--;
                                  });
                                }
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(26),
                                height: ScreenUtil().setWidth(26),
                                decoration: BoxDecoration(
                                    color: ColorPalette.lightGrey,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.remove,
                                  size: 20.sp,
                                  color: numberOfItems == 1
                                      ? ColorPalette.darkGrey
                                      : ColorPalette.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(20),
                            ),
                            Text(
                              numberOfItems.toString(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                  color: ColorPalette.black),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(20),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (widget.order.numberOfItems > numberOfItems)
                                  setState(() {
                                    numberOfItems++;
                                  });
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(26),
                                height: ScreenUtil().setWidth(26),
                                decoration: BoxDecoration(
                                    color: ColorPalette.lightGrey,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.add,
                                  size: 22.sp,
                                  color: numberOfItems ==
                                          widget.order.numberOfItems
                                      ? ColorPalette.darkGrey
                                      : ColorPalette.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
                      color: ColorPalette.lightGrey,
                    ),
                    child: BasicTextField(
                      expanded: true,
                      controller: cancelReasonController,
                      labelText: 'Please describe the issue',
                      validator: (value) {
                        if (value.isEmpty) {
                          return "* Required";
                        } else {
                          return null;
                        }
                      },
                      textInputType: TextInputType.multiline,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                LongBlueButton(
                  text: 'Proceed',
                  onPressed: () {
                    validate();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
