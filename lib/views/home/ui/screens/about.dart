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
        body:   SingleChildScrollView(
          child: Column(
            children: [
              const AppBarOfSpokify(),
              Padding(
                padding: const EdgeInsets.all(17.0),
                  child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: MyColors.backgroundColor,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
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
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),


                    ),
                  ),
                )

            ],
          ),
        ));
  }
}
