import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayDateWidget extends StatelessWidget {
  const DayDateWidget({super.key});

  String _getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('dd / MM / yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x3F000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: 35,
              height: 35,
              child: Image.asset("assets/icons/calendar.png"),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  _getFormattedDate(),
                  style: const TextStyle(
                    fontFamily: 'Inconsolata',
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}