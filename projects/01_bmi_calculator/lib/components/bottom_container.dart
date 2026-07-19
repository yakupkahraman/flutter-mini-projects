import 'package:flutter/material.dart';

class BottomContainer extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const BottomContainer({super.key, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: const Color(0xFFEB1555),
        margin: const EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: 65,
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
