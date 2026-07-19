import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularButton(
      {super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: const BoxConstraints.tightFor(
        width: 56.0,
        height: 56.0,
      ),
      elevation: 0.0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
      fillColor: const Color(0xFF4C4F5E),
      child: Icon(icon),
    );
  }
}
