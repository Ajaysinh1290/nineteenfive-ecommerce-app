import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class BankDetailsScreen extends StatefulWidget {
  Order order;
  ProductCancel? productCancel;
  ProductReturn? productReturn;

  BankDetailsScreen.cancelOrder(this.order, this.productCancel);

  BankDetailsScreen.returnOrder(this.order, this.productReturn);

  @override
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController reEnterAccountNumberController =
      TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController accountHolderName = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  validate() {
    if (formKey.currentState!.validate()) {
      if (widget.productCancel != null) {
        cancelProduct();
      } else {
        returnProduct();
      }
    }
  }

  cancelProduct() async {
    BankDetails bankDetails = BankDetails(
        accountNumber: accountNumberController.text,
        accountHolderName: accountHolderName.text,
        ifscCode: ifscCodeController.text);
    widget.productCancel!.bankDetails = bankDetails;
    widget.order.productCancel = widget.productCancel;
    widget.productCancel!.cancellationTime = DateTime.now();
    await FirebaseDatabase.storeOrder(widget.order,false);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  returnProduct() async {
    BankDetails bankDetails = BankDetails(
        accountNumber: accountNumberController.text,
        accountHolderName: accountHolderName.text,
        ifscCode: ifscCodeController.text);
    widget.productReturn!.bankDetails = bankDetails;
    widget.order.productReturn = widget.productReturn;
    widget.productReturn!.returnRequestTime = DateTime.now();
    await FirebaseDatabase.storeOrder(widget.order,false);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  String? validator(value) {
    if (value.isEmpty) {
      return "* Required";
    } else {
      return null;
    }
  }

  String? numValidator(value) {
    if (value.isEmpty) {
      return "* Required";
    } else {
      try {
        int.parse(value);
        return null;
      } catch (e) {
        return "Only numbers are allowed !";
      }
    }
  }

  String? reEnterAccountNumberValidator(value) {
    if (value.isEmpty) {
      return "* required";
    } else if (value.toString() != accountNumberController.text) {
      return "Account Number does not match..!";
    } else {
      return null;
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
        title: Text('Refund',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().setHeight(778),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setWidth(28), horizontal: 28),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Money will be credited directy to bank account after we get the returned item. Please Provide bank details to help us process funds.',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.black, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    BasicTextField(
                      labelText: 'Account Number',
                      validator: numValidator,
                      textInputType: TextInputType.number,
                      controller: accountNumberController,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    BasicTextField(
                      labelText: 'Re-enter Account Number',
                      validator: reEnterAccountNumberValidator,
                      textInputType: TextInputType.number,
                      controller: reEnterAccountNumberController,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    BasicTextField(
                      labelText: 'IFSC Code',
                      validator: validator,
                      controller: ifscCodeController,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    BasicTextField(
                      labelText: 'Account Holder Name',
                      validator: validator,
                      controller: accountHolderName,
                    ),
                  ],
                ),
                LongBlueButton(
                  text: widget.productCancel != null
                      ? "Cancel Order"
                      : "Confirm Return",
                  onPressed: validate,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
