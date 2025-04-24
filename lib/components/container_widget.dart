import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const ContainerWidget({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.padding,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.border,
    this.boxShadow = const [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 4,
        spreadRadius: 0,
        color: Color(0x3F000000),
      ),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
} 