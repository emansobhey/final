import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> askQuestion(String question) async {
  final uri = Uri.parse("http://192.168.1.102:8000/ask_question/"); // غيّر الـ IP حسب السيرفر
  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"question": question}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to get answer: ${response.body}");
  }
}
