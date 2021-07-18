import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget widget;
  final Curve? curve;
  final Duration? duration;
  final Alignment? alignment;

  //
  // CustomPageRoute(
  //     {this.alignment,
  //     this.duration,
  //     this.curve,
  //     required,
  //     required this.widget})
  //     : super(builder: (context) => widget);
  CustomPageRoute(
      {this.alignment, this.duration, this.curve, required this.widget})
      : super(
            transitionDuration: duration ?? Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondAnimation,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: curve??Curves.easeOutExpo);
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: alignment??Alignment.center,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondAnimation) {
              return widget;
            });
}
