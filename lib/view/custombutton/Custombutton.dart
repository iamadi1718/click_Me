import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  const Custombutton({
    super.key,
    required this.text,
    required this.onTap,
    required this.buttoncolor,
    required this.bordercolor,
    required this.textcolor,
  });
  final String text;
  final VoidCallback onTap;
  final Color buttoncolor;
  final Color bordercolor;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: buttoncolor,
            border: Border.all(width: 2, color: bordercolor),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),

          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: textcolor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
