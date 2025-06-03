import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/views/home/ui/widgets/app_bar_home.dart';
import 'package:gradprj/views/home/ui/widgets/bottom_bar_home.dart';
import 'package:gradprj/views/home/ui/widgets/note_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 41),
              child: AppBarHome(),
            ),
            verticalSpace(100),
            NoteContainer(
              height: 150,
              onTap: () {
                Navigator.pushNamed(context, Routes.notePage);
              },
              text: "AI-Driven tool for Smarter Workflows",
            ),
            verticalSpace(50),
            const BottomBarHome(),
          ],
        ),
      ),
    );
  }
}
