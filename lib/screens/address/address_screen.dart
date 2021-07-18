import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/models/address.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/screens/payment/bank_details_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/payment/payment_successfull.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/route/CustomPageRoute.dart';
import 'package:nineteenfive_ecommerce_app/widgets/text%20field/basic_text_field.dart';

class AddressScreen extends StatefulWidget {
  // List<Order> orders;
  Address? address;

  // bool isFromCart;
  // Order order;
  // ProductReturn productReturn;
  //
  // AddressScreen(this.orders, this.isFromCart);
  //
  AddressScreen.editAddress(this.address);

  //
  // AddressScreen.returnOrder(this.order, this.productReturn);

  AddressScreen.addAddress();

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController houseNoFlatNoFloorController = TextEditingController();
  TextEditingController societyOrStreetNameController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  String? validator(value) {
    if (value.isEmpty) {
      return "* Required";
    } else {
      return null;
    }
  }

  Future<void> validate() async {
    if (formKey.currentState!.validate()) {
      Address address = Address(
          addressId: DateTime.now().millisecondsSinceEpoch.toString(),
          name: nameController.text,
          mobileNumber: mobileNumberController.text,
          houseNoOrFlatNoOrFloor: houseNoFlatNoFloorController.text,
          societyOrStreetName: societyOrStreetNameController.text,
          landMark: landmarkController.text,
          area: areaController.text,
          city: cityController.text,
          state: stateController.text,
          pinCode: pinCodeController.text);

      if (widget.address != null) {
        widget.address!.name = address.name;
        widget.address!.mobileNumber = address.mobileNumber;
        widget.address!.houseNoOrFlatNoOrFloor = address.houseNoOrFlatNoOrFloor;
        widget.address!.societyOrStreetName = address.societyOrStreetName;
        widget.address!.landMark = address.landMark;
        widget.address!.area = address.area;
        widget.address!.state = address.state;
        widget.address!.city = address.city;
        widget.address!.pinCode = address.pinCode;
        // } else if (widget.orders != null) {
        //   widget.orders.forEach((element) {
        //     element.addressId = address.addressId;
        //   });
        //   StaticData.userData.addresses.add(address);
        // } else if (widget.order != null && widget.productReturn != null) {
        //   widget.productReturn.pickUpAddressId = address.addressId;
        //   StaticData.userData.addresses.add(address);
      } else {
        StaticData.userData.addresses!.add(address);
      }
      await FirebaseDatabase.storeUserData(StaticData.userData);
      // if (widget.orders != null) {
      //   Navigator.push(
      //       context,
      //       CustomPageRoute(
      //           widget: PaymentSuccessful(widget.orders, widget.isFromCart),
      //           alignment: Alignment.center,
      //           curve: Curves.elasticOut,
      //           duration: Duration(seconds: 1)));
      // } else if (widget.order != null && widget.productReturn != null) {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => BankDetailsScreen.returnOrder(
      //               widget.order, widget.productReturn)));
      // } else {
      Navigator.pop(context);
      // }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.address != null) {
      nameController.text = widget.address!.name;
      mobileNumberController.text = widget.address!.mobileNumber;
      houseNoFlatNoFloorController.text = widget.address!.houseNoOrFlatNoOrFloor;
      societyOrStreetNameController.text = widget.address!.societyOrStreetName;
      landmarkController.text = widget.address!.landMark;
      areaController.text = widget.address!.area;
      cityController.text = widget.address!.city;
      stateController.text = widget.address!.state;
      pinCodeController.text = widget.address!.pinCode;
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Address',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 28.sp),
            child: Column(
              children: [
                BasicTextField(
                  labelText: 'Full Name',
                  validator: validator,
                  controller: nameController,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                BasicTextField(
                  labelText: 'Mobile Number',
                  validator: validator,
                  controller: mobileNumberController,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                BasicTextField(
                  labelText: 'House No / Flat No / Floor',
                  validator: validator,
                  controller: houseNoFlatNoFloorController,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                BasicTextField(
                  labelText: 'Society / Street Name',
                  validator: validator,
                  controller: societyOrStreetNameController,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                BasicTextField(
                  labelText: 'Land mark',
                  validator: validator,
                  controller: landmarkController,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  children: [
                    Expanded(
                      child: BasicTextField(
                        labelText: 'Area',
                        validator: validator,
                        controller: areaController,
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(20),
                    ),
                    Expanded(
                      child: BasicTextField(
                        labelText: 'City',
                        validator: validator,
                        controller: cityController,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  children: [
                    Expanded(
                      child: BasicTextField(
                        labelText: 'State',
                        validator: validator,
                        controller: stateController,
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(20),
                    ),
                    Expanded(
                      child: BasicTextField(
                        labelText: 'Pin code',
                        validator: validator,
                        controller: pinCodeController,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                LongBlueButton(
                  onPressed: () {
                    validate();
                  },
                  text: widget.address != null ? 'Update' : 'Add Address',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
