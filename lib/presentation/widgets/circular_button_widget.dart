import 'package:flutter/material.dart';

class CircularButtonWidget extends StatelessWidget {
  final IconData iconData;
  final Function() onPressed;

  const CircularButtonWidget({
    super.key,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 248, 251, 255),
          shape: const CircleBorder(),
        ),
        onPressed: onPressed,
        child: Icon(
          iconData,
          size: 28,
          color: const Color.fromARGB(255, 55, 57, 82),
        ),
      ),
    );
  }
}
