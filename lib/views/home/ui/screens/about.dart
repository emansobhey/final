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
                        child: const Text(
                          'Spokify is a mobile-first AI-powered application\n'
                              'designed to transform spoken content into actionable insights.\n'
                              'It allows users to upload or record audio,\n'
                              'which is then transcribed, summarized,\n'
                              'and grammatically enhanced using Gemini 2.0 Flash.\n'
                              'Extracted tasks and key topics are identified\n'
                              'through a LangChain-powered RAG system\n'
                              'and seamlessly integrated with Trello\n'
                              'for visual task management.\n'
                              'The system is built using FastAPI and Flutter,\n'
                              'ensuring a responsive, scalable experience across platforms.\n'
                              'Designed for professionals, students, and educators,\n'
                              'Spokify enhances productivity by converting\n'
                              'unstructured voice notes into organized, structured outcomes.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.start,
                        ),

                  ),
                )

            ],
          ),
        ));
  }
}
