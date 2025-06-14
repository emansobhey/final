
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String _serviceId = 'service_liohz68';
  static const String _templateId = 'template_p2quqel';
  static const String _userId = '5zOdcrJU-FsYmwapV';

  static Future<bool> sendEmail({
    required String fromEmail,
    required String toEmail,
    required String message,
  }) async {
    const String _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';

    final Map<String, dynamic> templateParams = {
      'from_email': fromEmail,
      'to_email': toEmail,
      'message': message,
    };

    final Map<String, dynamic> requestBody = {
      'service_id': _serviceId,
      'template_id': _templateId,
      'user_id': _userId,
      'template_params': templateParams,
    };

    try {
      final response = await http.post(
        Uri.parse(_emailJsUrl),
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Exception sending email: $e');
      return false;
    }
  }
}