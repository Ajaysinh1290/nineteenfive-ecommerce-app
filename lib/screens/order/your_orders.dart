import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/order_details.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/my_order_card.dart';

import '../home/main_screen.dart';

class YourOrders extends StatefulWidget {
  final Function? onDrawerClick;

  YourOrders({this.onDrawerClick});

  @override
  _YourOrdersState createState() => _YourOrdersState();
}

class _YourOrdersState extends State<YourOrders> {
  List sortByList = ["All", "Ordered", "Cancelled", "Returned"];
  late String sortBy;
  int length = 0;
  ScrollController scrollController = new ScrollController();

  void initState() {
    // TODO: implement initState
    super.initState();
    sortBy = sortByList.first;
    // fetchOrders();
  }

  filterItemsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              title: Container(
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Text(
                      'Sort By',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: ColorPalette.lightGrey,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(3),
                    ),
                  ],
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(
                    //   height: ScreenUtil().setHeight(15),
                    // ),
                    // Text('Sort By',
                    //     style: Theme.of(context).textTheme.headline5),
                    // SizedBox(
                    //   height: ScreenUtil().setHeight(15),
                    // ),
                    Column(
                      children: List.generate(
                        sortByList.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              setState.call(() {
                                sortBy = sortByList[index];
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  sortByList[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: Colors.black),
                                ),
                                Spacer(),
                                Radio(
                                    value: sortByList[index],
                                    activeColor: ColorPalette.darkBlue,
                                    groupValue: sortBy,
                                    onChanged: (dynamic value) {
                                      setState.call(() {
                                        sortBy = value.toString();
                                      });
                                    })
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black),
                  ),
                ),
                // ignore: deprecated_member_use
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    filterProduct();
                  },
                  child: Text(
                    'Apply',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black),
                  ),
                )
              ],
            );
          });
        });
  }

  filterProduct() {
    setState(() {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
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
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              widget.onDrawerClick!();
            }
          },
        ),
        title: Text('Your Orders',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        actions: [
          IconButton(
            onPressed: () {
              filterItemsDialog();
            },
            icon: Icon(
              Icons.more_vert,
              size: ScreenUtil().setWidth(30),
              color: Colors.black,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            widget.onDrawerClick!();
          }
          return false;
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: StaticData.userData.orders == null ||
                  StaticData.userData.orders!.isEmpty
              ? Container(
                  height: ScreenUtil().setHeight(700),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/frown.png',
                        width: ScreenUtil().setWidth(170),
                        height: ScreenUtil().setHeight(170),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('No order found',
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 26.sp)),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Looks like you haven’t made order yet.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6)
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: StaticData.userData.orders!.length,
                  shrinkWrap: true,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('orders')
                          .doc(StaticData.userData.orders!.reversed
                              .toList()[index])
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        late Order order;
                        if (snapshot.hasData) {
                          order = Order.fromJson(snapshot.data.data());
                          if (sortBy == "Ordered" &&
                              (order.productCancel != null ||
                                  order.productReturn != null)) {
                            return Container();
                          } else if (sortBy == "Cancelled" &&
                              order.productCancel == null) {
                            return Container();
                          } else if (sortBy == "Returned" &&
                              order.productReturn == null) {
                            return Container();
                          }
                        }

                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 15),
                                padding: EdgeInsets.all(15.0),
                                height: ScreenUtil().setHeight(150),
                                decoration: BoxDecoration(
                                  color: ColorPalette.lightGrey,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetails(order)))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                child: MyOrderCard(order));
                      },
                    );
                  },
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: StaticData.userData.orders == null ||
              StaticData.userData.orders!.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: LongBlueButton(
                text: 'Start Shopping',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MainScreen()),
                      (Route<dynamic> route) => false);
                },
              ),
            )
          : Container(),
    );
  }
}
