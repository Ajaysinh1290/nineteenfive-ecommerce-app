import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/product/item_details.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/size_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';

class ItemCheckoutCard extends StatefulWidget {
  Product? product;
  final String? productId;
  final String? selectedSize;
  final bool? enableAnimation;
  final int? numberOfItems;
  final GestureTapCallback? onDeleted;
  final Function(int)? onNumberOfItemsChanged;
  final Function(String)? onSizeChanged;

  ItemCheckoutCard(
      {this.product,
      this.onDeleted,
      this.productId,
      this.selectedSize,
      this.numberOfItems,
      this.onNumberOfItemsChanged,
      this.onSizeChanged,
      this.enableAnimation});

  @override
  _ItemCheckoutCardState createState() => _ItemCheckoutCardState();
}

class _ItemCheckoutCardState extends State<ItemCheckoutCard> {
  String? selectedSize;

  int numberOfItems = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSize = widget.selectedSize;
    numberOfItems = widget.numberOfItems!;
    if (widget.product == null) {
      fetchProduct();
    }
  }

  fetchProduct() {
    StaticData.products.forEach((element) {
      if (element.productId == widget.productId) {
        widget.product = element;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetails(widget.product!)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                offset: Offset(1, 2),
                blurRadius: 20,
              ),
            ]),
        child: widget.product == null
            ? Container(
                color: Colors.grey[100],
                height: ScreenUtil().setWidth(120),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.enableAnimation ?? true
                        ? widget.product!.productId
                        : DateTime.now().millisecondsSinceEpoch.toString(),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().radius(15)),
                      child: ImageNetwork(
                        imageUrl: widget.product!.productImages.first,
                        width: ScreenUtil().setWidth(94),
                        height: ScreenUtil().setWidth(130),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(15),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product!.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(fontSize: 18.sp)),
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        Text(
                          Constants.currencySymbol +
                              widget.product!.productPrice.toString(),
                          style: GoogleFonts.openSans(
                              fontSize: 26.sp,
                              color: Colors.black,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(15),
                        ),
                        Wrap(
                          children: List.generate(
                              widget.product!.productSizes!.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                widget.onSizeChanged!
                                    .call(widget.product!.productSizes![index]);
                                setState(() {
                                  selectedSize =
                                      widget.product!.productSizes![index];
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SizeCard(
                                  size: widget.product!.productSizes![index],
                                  isSelected:
                                      widget.product!.productSizes![index] ==
                                          selectedSize,
                                ),
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.onDeleted != null)
                          GestureDetector(
                            child: Icon(
                              Icons.clear,
                              color: ColorPalette.darkGrey,
                              size: 20.sp,
                            ),
                            onTap: () {
                              widget.onDeleted!.call();
                            },
                          ),
                        SizedBox(
                          height: ScreenUtil().setHeight(30),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if(numberOfItems<widget.product!.availableStock) {
                                    numberOfItems++;
                                    widget.onNumberOfItemsChanged!
                                        .call(numberOfItems);
                                  }

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
                                  color: numberOfItems == widget.product!.availableStock?ColorPalette.darkGrey:ColorPalette.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              numberOfItems.toString(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                  color: ColorPalette.black),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (numberOfItems > 1) {
                                  setState(() {
                                    numberOfItems--;
                                  });
                                  widget.onNumberOfItemsChanged!
                                      .call(numberOfItems);
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
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
