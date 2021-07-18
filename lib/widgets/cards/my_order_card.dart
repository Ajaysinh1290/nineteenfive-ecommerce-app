import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/order_details.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';

class MyOrderCard extends StatefulWidget {
  final Order order;

  const MyOrderCard(this.order);

  @override
  _MyOrderCardState createState() => _MyOrderCardState();
}

class _MyOrderCardState extends State<MyOrderCard> {
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
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: Offset(1, 2),
              blurRadius: 20,
            ),
          ]),
      child: product == null
          ? Container(
              color: Colors.grey[100],
              height: ScreenUtil().setWidth(120),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: widget.order.orderId,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ImageNetwork(
                      imageUrl: product.productImages.first,
                      fit: BoxFit.cover,
                      width: ScreenUtil().setWidth(94),
                      height: ScreenUtil().setWidth(120),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.productName,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(fontSize: 18.sp)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        Constants.currencySymbol +
                            (product.productPrice *
                                    widget.order.numberOfItems)
                                .toString(),
                        style: GoogleFonts.openSans(
                            fontSize: 22.sp,
                            color: Colors.black,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      widget.order.productCancel != null
                          ? Text(
                              "Order cancelled",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontSize: 16.sp),
                            )
                          : widget.order.productReturn != null
                              ? Text(
                                  widget.order.productReturn!.refundTime !=
                                          null
                                      ? "Refunded on " +
                                          Constants.onlyDateFormat.format(widget
                                              .order.productReturn!.refundTime??DateTime.now())
                                      : widget.order.productReturn!.productReceivedTime !=
                                              null
                                          ? "Product received back on " +
                                              Constants.onlyDateFormat.format(
                                                  widget.order.productReturn!
                                                      .productReceivedTime??DateTime.now())
                                          : widget.order.productReturn!
                                                      .productPickupTime !=
                                                  null
                                              ? "Product picked on " +
                                                  Constants.onlyDateFormat
                                                      .format(widget
                                                          .order
                                                          .productReturn!
                                                          .productReceivedTime??DateTime.now())
                                              : "Requested for return on " +
                                                  Constants.onlyDateFormat
                                                      .format(widget.order.productReturn!.returnRequestTime??DateTime.now()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(fontSize: 16.sp),
                                )
                              : Text(
                                  widget.order.deliveryTime != null
                                      ? "Delivered on " +
                                          Constants.onlyDateFormat.format(
                                              widget.order.deliveryTime??DateTime.now())
                                      : widget.order.outForDeliveryTime !=
                                              null
                                          ? "Out for delivery on" +
                                              Constants.onlyDateFormat.format(
                                                  widget.order
                                                      .outForDeliveryTime??DateTime.now())
                                          : widget.order.shippingTime != null
                                              ? "Shipped on " +
                                                  Constants.onlyDateFormat
                                                      .format(widget
                                                          .order.shippingTime??DateTime.now())
                                              : "Ordered on " +
                                                  Constants.onlyDateFormat
                                                      .format(widget
                                                          .order.orderTime??DateTime.now()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(fontSize: 16.sp))
                    ],
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
              ],
            ),
    );
  }
}
