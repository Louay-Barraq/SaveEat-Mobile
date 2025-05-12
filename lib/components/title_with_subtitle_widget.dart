import 'package:flutter/material.dart';

class NameDisplayWidget extends StatelessWidget {
  final String name;

  const NameDisplayWidget({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
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
          name,
          style: const TextStyle(
            fontFamily: 'Inconsolata',
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
