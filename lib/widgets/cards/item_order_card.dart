import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/size_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';

class ItemOrderCard extends StatefulWidget {
  final Order order;

  const ItemOrderCard(this.order);

  @override
  _ItemOrderCardState createState() => _ItemOrderCardState();
}

class _ItemOrderCardState extends State<ItemOrderCard> {
  late Product product;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProduct();
  }

  fetchProduct() {
    StaticData.products.forEach((element) {
      if (element.productId == widget.order.productId) {
        product = element;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15)),
      padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: widget.order.orderId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ImageNetwork(
                imageUrl: product.productImages.first,
                width: ScreenUtil().setWidth(94),
                height: ScreenUtil().setWidth(130),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.black, fontSize: 18.sp)),
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    Text(
                      Constants.currencySymbol +
                          widget.order.totalAmount.toString(),
                      style: GoogleFonts.openSans(
                          fontSize: 24.sp,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.order.productSize != null)
                      Padding(
                        padding:  EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                        child: Row(
                          children: [
                            Text(
                              'Size : ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.black),
                            ),
                            SizeCard(
                              isSelected: true,
                              size: widget.order.productSize,
                              margin: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),

                    Row(
                      children: [
                        Text(
                          'Qty : ',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black),
                        ),
                        SizeCard(
                          isSelected: true,
                          size: widget.order.numberOfItems.toString(),
                          selectedItemTextColor: Colors.black,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
