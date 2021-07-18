import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/product/item_details.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool? enableAnimation;
  final String? heroTag;
  bool? showOff;
  final Function(bool)? onLikeButtonPressed;

  ProductCard(this.product,
      {this.enableAnimation,
      this.onLikeButtonPressed,
      this.heroTag,
      this.showOff});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isLiked = false;
  bool likeButtonPressed = false;

  @override
  void initState() {
    super.initState();
  }

  String getOfferDiscount() {
    double off = 100 -
        widget.product.productPrice *
            100 /
            (widget.product.productMrp ?? widget.product.productPrice);
    return off.roundToDouble().toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    if (StaticData.userData.likedProducts == null) {
      StaticData.userData.likedProducts = [];
      isLiked = false;
    } else {
      isLiked =
          StaticData.userData.likedProducts!.contains(widget.product.productId);
    }
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(10),
          top: ScreenUtil().setWidth(10),
          right: ScreenUtil().setWidth(10),
          bottom: ScreenUtil().setWidth(10)),
      margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
          border: Border.all(color: ColorPalette.lightGrey, width: 2)),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Hero(
                  tag: widget.enableAnimation ?? true
                      ? widget.heroTag ?? widget.product.productId
                      : DateTime.now().millisecondsSinceEpoch.toString(),
                  child: Container(
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().radius(20)),
                        child: ImageNetwork(
                          imageUrl: widget.product.productImages.first,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 0, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                Constants.currencySymbol +
                                    widget.product.productPrice.toString(),
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 0.5,
                                    fontSize: 20.sp),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              if (widget.product.productMrp != null)
                                Text(
                                  Constants.currencySymbol +
                                      widget.product.productMrp.toString(),
                                  style: GoogleFonts.openSans(
                                      color: ColorPalette.darkGrey,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      decoration: TextDecoration.lineThrough),
                                )
                            ],
                          ),
                          Text(
                            widget.product.productName.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    fontSize: 12.sp,
                                    color: ColorPalette.darkGrey),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        likeButtonPressed = true;
                        if (StaticData.userData.likedProducts != null) {
                          if (isLiked) {
                            StaticData.userData.likedProducts!
                                .remove(widget.product.productId);
                          } else {
                            StaticData.userData.likedProducts!
                                .add(widget.product.productId);
                          }
                        }

                        await FirebaseDatabase.storeUserData(
                            StaticData.userData);
                        Future.delayed(Duration(milliseconds: 500))
                            .then((value) {
                          setState(() {
                            likeButtonPressed = false;
                          });
                        });
                        widget.onLikeButtonPressed?.call(!isLiked);
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear,
                        width: ScreenUtil().setWidth(30),
                        height: ScreenUtil().setWidth(30),
                        decoration: BoxDecoration(
                          color: likeButtonPressed && isLiked
                              ? ColorPalette.darkBlue
                              : likeButtonPressed && !isLiked
                                  ? ColorPalette.lightGrey
                                  : ColorPalette.lightGrey,
                          shape: BoxShape.circle,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: isLiked
                          //         ? ColorPalette.darkBlue.withOpacity(
                          //             likeButtonPressed ? 0.5 : 0)
                          //         : ColorPalette.black.withOpacity(
                          //             likeButtonPressed ? 0.17 : 0),
                          //     offset: Offset(2, 2),
                          //     blurRadius: 20,
                          //     spreadRadius: 0,
                          //   )
                          // ]
                        ),
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          color: likeButtonPressed && isLiked
                              ? ColorPalette.white
                              : isLiked
                                  ? ColorPalette.darkBlue
                                  : ColorPalette.grey,
                          size: ScreenUtil().setWidth(10),
                        ),
                      ),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          if ((widget.showOff ?? false) && widget.product.productMrp!=null&&(widget.product.productPrice != widget.product.productMrp))
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white70, shape: BoxShape.circle),
                child: Text(
                  getOfferDiscount() + "%\nOff",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: ColorPalette.black, fontSize: 12.sp, height: 1.2),
                ),
              ),
            )
        ],
      ),
    );
  }
}
