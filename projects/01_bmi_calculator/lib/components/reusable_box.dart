import 'package:flutter/material.dart';

class ReusableBox extends StatelessWidget {
  const ReusableBox({super.key, required this.colour, required this.cardChild});
  final Color colour;
  final Widget cardChild;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: colour, borderRadius: BorderRadius.circular(10)),
      child: cardChild,
    );
  }
}
