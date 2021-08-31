import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';

class MyDialog {

  static showLoading(BuildContext context) async {
    double angle = 0;
    double length = 130;
    late Timer timer;
    var data = await showDialog(
        context: context,
        barrierColor: ColorPalette.black.withOpacity(0.1),
        barrierDismissible: false,
        builder: (context) {
          return MyStatefulBuilder(
            builder: (context, setState) {
              timer = Timer(Duration(milliseconds: 1), () {
                  setState.call(() {
                    angle += 1;
                  });
              });
              return SimpleDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: EdgeInsets.zero,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                        child: Stack(
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(length),
                              height: ScreenUtil().setWidth(length),
                              padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(30)),
                              child: Image.asset(
                                'assets/logo/nineteenfive_logo.png',
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setHeight(80),
                                alignment: Alignment.center,
                              ),
                            ),
                            RotationTransition(
                                turns: AlwaysStoppedAnimation(angle / 360),
                                child: AnimatedContainer(
                                  duration: Duration(seconds: 1),
                                  width: ScreenUtil().setWidth(length),
                                  height: ScreenUtil().setWidth(length),
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    child: Image.asset(
                                      'assets/icons/half_colored_circle_thick.png',
                                      width: ScreenUtil().setWidth(length),
                                      height: ScreenUtil().setWidth(length),
                                    ),
                                  ),
                                )),
                          ],
                        )),
                  )
                ],
              );
            },
            dispose: () {
              timer.cancel();
            },
          );
        });
  }

  //
  static showMyDialog(BuildContext context, String? text) {
    showDialog(
        context: context,
        barrierColor: ColorPalette.black.withOpacity(0.2),
        builder: (context) {
          return AlertDialog(
            title: Text(
              text!,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black),
            ),
            actions: [
              RaisedButton(
                color: Theme.of(context).buttonColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ok',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black),
                ),
              )
            ],
          );
        });
  }
}

typedef Disposer = void Function();

class MyStatefulBuilder extends StatefulWidget {
  const MyStatefulBuilder({
    Key? key,
    required this.builder,
    required this.dispose,
  }) : super(key: key);

  final StatefulWidgetBuilder builder;
  final Disposer dispose;

  @override
  _MyStatefulBuilderState createState() => _MyStatefulBuilderState();
}

class _MyStatefulBuilderState extends State<MyStatefulBuilder> {
  @override
  Widget build(BuildContext context) => widget.builder(context, setState);

  @override
  void dispose() {
    super.dispose();
    widget.dispose();
  }
}
