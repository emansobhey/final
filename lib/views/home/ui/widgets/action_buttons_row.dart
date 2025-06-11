import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/custom_raised_gradientbutton.dart';

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onFetchTasks;
  final VoidCallback onFetchSummary;
  final VoidCallback onTrelloPressed;
  final VoidCallback onFetchTopics;

  const ActionButtonsRow({
    super.key,
    required this.onFetchTasks,
    required this.onFetchSummary,
    required this.onTrelloPressed,
    required this.onFetchTopics,
  });


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CustomRaisedGradientButton(
            width: 130,
            onPressed:onFetchTasks,
            text: 'Extracted Tasks',
          ),
          const SizedBox(width: 16),
          CustomRaisedGradientButton(
            width: 130,
            onPressed: onFetchSummary,
            text: 'Summarization',
          ),
          const SizedBox(width: 16),
          CustomRaisedGradientButton(
            width: 130,
            onPressed:onTrelloPressed,
            text: 'Add to Trello',
          ),
          const SizedBox(width: 16),
          CustomRaisedGradientButton(
            width: 130,
            onPressed:onFetchTopics,
            text: 'Detect Topics',
          ),
        ],
      ),
    );
  }
}
