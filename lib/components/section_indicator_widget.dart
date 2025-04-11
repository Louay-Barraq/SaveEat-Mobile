import 'package:flutter/material.dart';

class SectionIndicatorWidget extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const SectionIndicatorWidget({
    super.key,
    required this.title,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 2,
            color: Color(0x3F000000),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Inconsolata',
            fontWeight: FontWeight.w400,
            fontSize: 24,
            letterSpacing: 4,
            shadows: [
              Shadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}