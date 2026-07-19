import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;

  const MyButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: IconButton(
        icon: icon,
        color: Theme.of(context).colorScheme.inversePrimary,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
