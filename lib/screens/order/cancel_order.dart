import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/screens/payment/bank_details_screen.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/item_order_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class CancelOrder extends StatefulWidget {
  Order order;

  CancelOrder(this.order);

  @override
  _CancelOrderState createState() => _CancelOrderState();
}

class _CancelOrderState extends State<CancelOrder> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController cancelReasonController = TextEditingController();

  validate() {
    if (formKey.currentState!.validate()) {
      ProductCancel productCancel = ProductCancel(
        cancelReason: cancelReasonController.text,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BankDetailsScreen.cancelOrder(widget.order, productCancel)));
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
        title: Text('Cancel Order',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().setHeight(775),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setWidth(28), horizontal: 28),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ItemOrderCard(widget.order),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    color: ColorPalette.lightGrey,
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
