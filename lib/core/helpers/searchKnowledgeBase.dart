import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'ipconfig.dart';

Future<String> askQuestion(String question) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString("userId");

  if (userId == null) {
    throw Exception("User ID not found.");
  }

  final uri = Uri.parse("http://$ipAddress:8000/ask_question/");
  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "question": question,
      "user_id": userId, // ✅ نرسل الـ user_id
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["answer"] ?? "No answer found.";
  } else {
    throw Exception("Failed to get answer: ${response.statusCode}");
  }
}
