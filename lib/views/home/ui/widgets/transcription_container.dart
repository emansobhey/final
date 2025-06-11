import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class TranscriptionContainer extends StatelessWidget {
  final String? transcription;

  const TranscriptionContainer({super.key, required this.transcription});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Original Text:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: MyColors.backgroundColor,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: MyColors.button1Color.withOpacity(0.5), // ظل بنفسجي
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: transcription == null || transcription!.isEmpty
                ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
              transcription!,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
