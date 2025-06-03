import 'package:flutter/material.dart';

class CustomGestureDetector extends StatelessWidget {
  const CustomGestureDetector({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize:14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
