import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/theming/my_colors.dart';

Future<void> addTasksToTrello({
  required String boardName,
  required String listName,
  required BuildContext context,
}) async {
  try {
    final dio = Dio();
    final response = await dio.post(
      'http://192.168.1.102:8000/extract_and_add_tasks/',
      data: {
        "board_name": boardName,
        "list_name": listName,
      },
      options: Options(headers: {
        "Content-Type": "application/json",
      }),
    );

    // ✅ Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Tasks were successfully added to Trello."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  } catch (e) {
    // ❌ Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("❌ Failed to add tasks to Trello: $e"),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
void showTrelloInputDialog(BuildContext context) {
  final boardController = TextEditingController();
  final listController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dialogWidth = MediaQuery.of(context).size.width * 0.9;
          return SingleChildScrollView(
            child: Container(
              width: dialogWidth,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: MyColors.backgroundColor,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add to Trello",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: boardController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Board Name',
                      hintText: 'Enter board name',
                      labelStyle: const TextStyle(color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: listController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'List Name',
                      hintText: 'Enter list name',
                      labelStyle: const TextStyle(color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final boardName = boardController.text.trim();
                          final listName = listController.text.trim();

                          if (boardName.isEmpty || listName.isEmpty) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill in both Board and List names."),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          Navigator.pop(context);
                          addTasksToTrello(
                            boardName: boardName,
                            listName: listName,
                            context: context,
                          );
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
