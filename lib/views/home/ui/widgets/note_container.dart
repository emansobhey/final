import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';

class NoteContainer extends StatelessWidget {
  const NoteContainer({
    super.key,
    required this.text,
    this.onTap,
    this.height,
  });
  final String text;
  final void Function()? onTap;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                colors: <Color>[
                  MyColors.button1Color,
                  MyColors.button2Color,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 14, right: 14),
              child: Text(
                text,
                style: MyFontStyle.font18RegularAcc
                    .copyWith(color: MyColors.whiteColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }
}
