import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleSwitchComponentWidget extends StatefulWidget {
  final String title;

  const ToggleSwitchComponentWidget({
    super.key,
    required this.title,
  });

  @override
  State<ToggleSwitchComponentWidget> createState() => _ToggleSwitchComponentWidgetState();
}

class _ToggleSwitchComponentWidgetState extends State<ToggleSwitchComponentWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 75,
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
      child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Inconsolata',
                fontWeight: FontWeight.w300,
                fontSize: 21,
              ),
            ),
          ),

        const Spacer(),

        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: CupertinoSwitch(
            activeTrackColor: Color(0xFF0A8DC8),
            value: isSelected,
            onChanged: (bool newValue) {
              setState(() {
                isSelected = newValue;
              });
            },
          ),
        ),
      ],
    ),
    );
  }
}
