import 'package:flutter/material.dart';

class BottomSheetOnly extends StatelessWidget {
  const BottomSheetOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: DraggableScrollableSheet(
          initialChildSize: 0.15,
          minChildSize: 0.15,
          maxChildSize: 0.95,
          builder: (context, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2E3244),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // 4 icons at the bottom
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.share, color: Colors.white),
                      Icon(Icons.image, color: Colors.white),
                      Icon(Icons.copy, color: Colors.white),
                      Icon(Icons.delete, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('+ add tags',
                          style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("view transcript"),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.mic, size: 18),
                        label: const Text("append to note"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
