import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class ImageCircleAvatar extends StatelessWidget {
  const ImageCircleAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: MyColors.button1Color,
          child: Text(
            "S",
            style: TextStyle(fontSize: 50, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change profile picture')),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.edit,
                  size: 16, color: MyColors.button1Color),
            ),
          ),
        ),
      ],
    );
  }
}
