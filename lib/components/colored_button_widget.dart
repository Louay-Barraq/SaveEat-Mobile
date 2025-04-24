import 'package:flutter/material.dart';

class ColoredButtonWidget extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;

  const ColoredButtonWidget({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.textColor = Colors.white,
    this.onPressed,
    this.height = 50,
    this.width = double.infinity,
    this.borderRadius = 10,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: 'Inconsolata',
            ),
          ),
        ),
      ),
    );
  }
}
