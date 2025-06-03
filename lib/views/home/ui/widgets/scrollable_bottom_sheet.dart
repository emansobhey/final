import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class CustomDraggableScrollableSheet extends StatelessWidget {
  const CustomDraggableScrollableSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.13,
      minChildSize: 0.08,
      maxChildSize: 0.5,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: MyColors.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: ListView(
            controller: controller,
            padding: EdgeInsets.all(12),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              verticalSpace(20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.share, color: MyColors.whiteColor),
                  Icon(Icons.image, color: MyColors.whiteColor),
                  Icon(Icons.copy, color: MyColors.whiteColor),
                  Icon(Icons.delete, color: MyColors.whiteColor),
                ],
              ),
              verticalSpace(20),
              const Center(
                child: Text(
                  "+ add tags",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              verticalSpace(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: Text("view transcript"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.mic, color: Colors.white),
                    label: const Text("append to note"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              verticalSpace(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Summarizing"),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: Colors.white),
                    label: const Text("detected topics"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
