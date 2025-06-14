import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> fetchTranscriptionTitle() async {
  final url = Uri.parse('http://192.168.1.102:8000/extract_title/'); // ← عدلي IP هنا

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['title']; // ← بترجع العنوان
    } else {
      print('Server Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Failed to fetch title: $e');
    return null;
  }
}
// ← ملف فيه fetchTranscriptionTitle()