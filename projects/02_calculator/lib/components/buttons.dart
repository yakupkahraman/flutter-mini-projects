import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  const NumberButton({
    super.key,
    required this.mytext,
    required this.onPressed,
  });

  final String mytext;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          overlayColor: WidgetStatePropertyAll(Colors.grey[300]),
          shape: const WidgetStatePropertyAll(CircleBorder()),
          minimumSize: WidgetStatePropertyAll(Size(deviceWidth / 4 - 15, 100))),
      child: Text(
        mytext,
        style: const TextStyle(
            fontSize: 40, color: Colors.black, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class OperateButton extends StatelessWidget {
  const OperateButton({
    super.key,
    required this.mytext,
    required this.onPressed,
  });

  final String mytext;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey[300]),
          overlayColor: WidgetStatePropertyAll(Colors.grey[400]),
          shape: const WidgetStatePropertyAll(CircleBorder()),
          minimumSize: WidgetStatePropertyAll(Size(deviceWidth / 4 - 15, 100))),
      child: Text(
        mytext,
        style: const TextStyle(
            fontSize: 40, color: Colors.green, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class EraserButton extends StatelessWidget {
  const EraserButton({
    super.key,
    required this.mytext,
    required this.onPressed,
  });

  final String mytext;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey[300]),
          overlayColor: WidgetStatePropertyAll(Colors.grey[400]),
          shape: const WidgetStatePropertyAll(CircleBorder()),
          minimumSize: WidgetStatePropertyAll(Size(deviceWidth / 4 - 15, 100))),
      child: Text(
        mytext,
        style: const TextStyle(
          fontSize: 40,
          color: Colors.red,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
