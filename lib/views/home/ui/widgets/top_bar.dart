import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.backgroundColor,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Image.asset("assets/images/arrow.png", width: 35, height: 35),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

