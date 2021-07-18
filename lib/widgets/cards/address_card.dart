import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/models/address.dart';
import 'package:nineteenfive_ecommerce_app/screens/address/address_screen.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';

class AddressCard extends StatefulWidget {
  final Address address;
  final bool isSelected;
  final Function? onDeleted;

  AddressCard(this.address, this.isSelected, {this.onDeleted});

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOutQuart,
      margin: EdgeInsets.symmetric(
          vertical: widget.isSelected
              ? ScreenUtil().setHeight(25)
              : ScreenUtil().setHeight(15),
          horizontal: 10),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: widget.isSelected ? ColorPalette.blue : Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: Offset(-6.0, -6.0),
            blurRadius: 15.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(2.0, 2.0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.address.name +
                      "\n" +
                      widget.address.houseNoOrFlatNoOrFloor +
                      " " +
                      widget.address.societyOrStreetName +
                      "\n" +
                      widget.address.landMark +
                      "\n" +
                      widget.address.area +
                      ", " +
                      widget.address.city +
                      "\n" +
                      widget.address.state +
                      ", " +
                      widget.address.pinCode +
                      "\n" +
                      widget.address.mobileNumber,
                  style: GoogleFonts.poppins(
                      letterSpacing: 0.7,
                      fontWeight: FontWeight.w500,
                      color: widget.isSelected ? Colors.black : Colors.black,
                      fontSize: 16.sp),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onDeleted?.call();
                },
                child: Icon(
                  Icons.clear,
                  color: widget.isSelected
                      ? ColorPalette.black
                      : ColorPalette.darkGrey,
                  size: 22.sp,
                ),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddressScreen.editAddress(widget.address)))
                    .then((value) {
                  setState(() {});
                });
              },
              child: Container(
                width: ScreenUtil().setWidth(26),
                height: ScreenUtil().setWidth(26),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isSelected
                        ? Colors.white
                        : ColorPalette.lightGrey),
                child: Icon(
                  Icons.edit,
                  size: 17.sp,
                  color: ColorPalette.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
