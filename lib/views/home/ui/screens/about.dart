import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/app_bar.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class about extends StatelessWidget {
  const about({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: Column(
          children: [
            const AppBarOfSpokify(),
            verticalSpace(80),
            const Padding(
              padding: EdgeInsets.all(17.0),
              child: Text(
                '''
Spokify is your smart voice companion.
It helps you record, transcribe, and analyze your voice notes easily. Whether you're brainstorming, attending meetings, or capturing ideas, Spokify organizes your audio and turns it into structured, meaningful text.

🔹 Key Features:

* Real-time voice recording.

* Smart transcription using AI.

* Keyword search & content highlights.

* Ask questions about past recordings.

* Easy sharing and task creation.''',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ));
  }
}
