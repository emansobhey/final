import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class SummaryContainer extends StatelessWidget {
  final bool isSummarizing;
  final String? summaryText;
  final String? summaryError;

  const SummaryContainer({
    super.key,
    required this.isSummarizing,
    required this.summaryText,
    required this.summaryError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(' Summary:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [MyColors.button1Color, MyColors.button2Color]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: isSummarizing
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : summaryError != null
              ? Text(summaryError!, style: const TextStyle(color: Colors.white))
              : Text(summaryText ?? "No summary available.",
              style: const TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }
}
