import 'package:flutter/material.dart';

class Custombackground extends StatelessWidget {
  const Custombackground({super.key, required this.widget});
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(160, 133, 186, 1),
            Color.fromRGBO(255, 218, 123, 1),
          ],
        ),
      ),
      child: widget,
    );
  }
}
