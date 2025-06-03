import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final void Function()? onPressed;

  const RaisedGradientButton({
    super.key,
    required this.child,
    required this.gradient,
    this.width = double.infinity / 1.5,
    this.height = 60.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 60.0,
      decoration: BoxDecoration(
          gradient: gradient, borderRadius: BorderRadius.circular(15)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
