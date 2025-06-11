import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class TasksList extends StatelessWidget {
  final List<String> tasks;

  const TasksList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(' Extracted Tasks:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 16),
        ...tasks.map((task) => Card(
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
              leading: const Icon(Icons.check_circle_outline, color: Colors.white),
              title: Text(task, style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        )),
      ],
    );
  }
}
