import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/item_order_card.dart';
import 'package:async/async.dart';

class TrackOrder extends StatefulWidget {
  final Order order;

  TrackOrder(this.order);

  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  List<double> trackHeight = [0, 0, 0, 0, 0, 0, 0, 0];
  int delayTime = 500;
  double trackMaxHeight = 75;

  List<CancelableOperation> cancellableOperation = [];

  getContainer(bool isActive) {
    return Container(
        alignment: Alignment.center,
        width: ScreenUtil().setHeight(34),
        height: ScreenUtil().setHeight(34),
        decoration: BoxDecoration(
            color: isActive
                ? ColorPalette.darkBlue.withOpacity(0.15)
                : Colors.transparent,
            shape: BoxShape.circle),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          width: ScreenUtil().setHeight(14),
          height: ScreenUtil().setHeight(14),
          decoration: BoxDecoration(
              color: isActive ? ColorPalette.darkBlue : Colors.grey[200],
              shape: BoxShape.circle),
        ));
  }

  getTrack(bool isActive, int index) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            height: trackMaxHeight,
            width: 2,
            color: Colors.grey[200],
          ),
          if (isActive)
            AnimatedContainer(
              duration: Duration(milliseconds: delayTime),
              height: trackHeight[index],
              color: ColorPalette.darkBlue,
              width: 2,
            )
        ],
      ),
    );
  }

  getItemDetails(title, date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(date == null ? 'Processing' : Constants.dateFormat.format(date),
            style: Theme.of(context).textTheme.headline6),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    trackMaxHeight = ScreenUtil().setHeight(84);
    print(widget.order.orderTime);

    int length = widget.order.productReturn != null ? 8 : 4;
    for (int i = 0; i < length; i++) {
      cancellableOperation.add(CancelableOperation.fromFuture(
        Future.delayed(Duration(milliseconds: (delayTime * i) + 100))
            .then((value) {
          setState(() {
            trackHeight[i] = trackMaxHeight;
          });
        }),
        onCancel: () => {},
      ));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cancellableOperation.forEach((element) {
      element.cancel();
    });
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
        title: Text('Track Order',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(28), horizontal: 28),
          child: Column(
            children: [
              ItemOrderCard(widget.order),
              Container(
                height: ScreenUtil()
                    .setHeight(widget.order.productReturn != null ? 850 : 425),
                padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        getContainer(widget.order.orderTime != null),
                        getTrack(widget.order.orderTime != null, 0),
                        getContainer(widget.order.shippingTime != null &&
                            trackHeight[1] != 0),
                        getTrack(widget.order.shippingTime != null, 1),
                        getContainer(widget.order.outForDeliveryTime != null &&
                            trackHeight[2] != 0),
                        getTrack(widget.order.outForDeliveryTime != null, 2),
                        getContainer(widget.order.deliveryTime != null &&
                            trackHeight[3] != 0),
                        if (widget.order.productReturn != null)
                          Container(
                            height: ScreenUtil().setHeight(425),
                            child: Column(
                              children: [
                                getTrack(widget.order.deliveryTime != null, 3),
                                getContainer(widget.order.productReturn!
                                            .returnRequestTime !=
                                        null &&
                                    trackHeight[4] != 0),
                                getTrack(
                                    widget.order.productReturn!
                                            .returnRequestTime !=
                                        null,
                                    4),
                                getContainer(widget.order.productReturn!
                                            .productPickupTime !=
                                        null &&
                                    trackHeight[5] != 0),
                                getTrack(
                                    widget.order.productReturn!
                                            .productPickupTime !=
                                        null,
                                    5),
                                getContainer(widget.order.productReturn!
                                            .productReceivedTime !=
                                        null &&
                                    trackHeight[6] != 0),
                                getTrack(
                                    widget.order.productReturn!
                                            .productReceivedTime !=
                                        null,
                                    6),
                                getContainer(
                                    widget.order.productReturn!.refundTime !=
                                            null &&
                                        trackHeight[7] != 0),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(50),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getItemDetails('Order Placed', widget.order.orderTime),
                        getItemDetails('Shipped', widget.order.shippingTime),
                        getItemDetails('Out for Delivery',
                            widget.order.outForDeliveryTime),
                        getItemDetails('Delivered', widget.order.deliveryTime),
                        if (widget.order.productReturn != null)
                          getItemDetails('Return Request',
                              widget.order.productReturn!.returnRequestTime),
                        if (widget.order.productReturn != null)
                          getItemDetails('Picked up',
                              widget.order.productReturn!.productPickupTime),
                        if (widget.order.productReturn != null)
                          getItemDetails('Product received back',
                              widget.order.productReturn!.productReceivedTime),
                        if (widget.order.productReturn != null)
                          getItemDetails('Refunded',
                              widget.order.productReturn!.refundTime),
                      ],
                    ))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
