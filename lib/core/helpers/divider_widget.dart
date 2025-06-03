import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    super.key,
    required this.color,
    required this.height,
  });
  final Color color;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: 1,
      height: height,
    );
  }
}
