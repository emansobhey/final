import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class TopicsList extends StatelessWidget {
  final List<String> topics;

  const TopicsList({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(' Detected Topics:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 16),
        ...topics.map((topic) => Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MyColors.button1Color, MyColors.button2Color],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.topic, color: Colors.white),
              title: Text(topic, style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        )),
      ],
    );
  }
}
