import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/order_details.dart';
import 'package:nineteenfive_ecommerce_app/screens/home/main_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/your_orders.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/button/long_blue_button.dart';

class PaymentSuccessful extends StatefulWidget {
  final List<Order> orders;
  const PaymentSuccessful(this.orders);

  @override
  _PaymentSuccessfulState createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainScreen()),
              (Route<dynamic> route) => false);
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: ScreenUtil().setHeight(900),
            padding: EdgeInsets.all(ScreenUtil().setWidth(28)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(80),
                ),
                AvatarGlow(
                  endRadius: ScreenUtil().setWidth(150),
                  showTwoGlows: true,
                  glowColor: ColorPalette.darkBlue,
                  child: Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                      width: ScreenUtil().setWidth(180),
                      height: ScreenUtil().setWidth(180),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [
                                Color(0xffE1F8FF),
                                ColorPalette.darkBlue,
                              ],
                              stops: [
                                0.1,
                                1.2
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)),
                      child: Image.asset(
                        'assets/icons/done.png',
                      )),
                ),
                Text(
                  'Payment Successfull',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'Hooray! Your Payment process has been completed and your order placed successfully. ',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),

                  ],
                ),
                Spacer(),
                LongBlueButton(
                  text: 'View Order Details',
                  onPressed: () {
                    if(widget.orders.length==1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetails(widget.orders.first)));
                    }else {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>YourOrders()));
                    }
                  },
                ),
                SizedBox(height: ScreenUtil().setHeight(15)),
                LongBlueButton(
                  color: ColorPalette.lightGrey,
                  text: 'Back to Home',
                  onPressed: (){
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MainScreen()),
                            (Route<dynamic> route) => false);
                  },
                ),
                SizedBox(height: ScreenUtil().setHeight(15)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
