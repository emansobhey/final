

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    print("✅ Response: ${response.data}");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("send to Trello"),
        content: Text("${response.data['message']}"),
        actions: [
          TextButton(
            child: const Text("close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  } catch (e) {
    print("❌ Error: $e");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("wrong"),
        content: Text("can't send to Trello: $e"),
        actions: [
          TextButton(
            child: const Text("close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
