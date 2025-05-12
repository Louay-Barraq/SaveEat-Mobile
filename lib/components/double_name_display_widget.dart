import 'package:flutter/material.dart';
import 'package:save_eat/utils/helper_funcs.dart';

class TitleWithSubtitleWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const TitleWithSubtitleWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
              title.toUpperCase(),
              style: const TextStyle(
                letterSpacing: 4,
                fontFamily: 'Inconsolata',
                fontWeight: FontWeight.w500,
                fontSize: 36,
              ),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 80),
          height: 55,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade700,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
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
              subtitle,
              style: const TextStyle(
                fontFamily: 'Inconsolata',
                fontWeight: FontWeight.w400,
                fontSize: 26,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
