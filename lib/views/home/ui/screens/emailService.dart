import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  // TODO: استبدلي هذه القيم بالقيم الحقيقية الخاصة بحساب EmailJS لديك
  static const String _serviceId =
      'service_liohz68'; // استبدلي بـ Service ID من EmailJS
  static const String _templateId =
      'template_p2quqel'; // استبدلي بـ Template ID من EmailJS
  static const String _userId =
      '5zOdcrJU-FsYmwapV'; // استبدلي بـ User ID (Public Key) من EmailJS

  /// ترسل الإيميل عبر EmailJS API
  /// [fromEmail]: البريد الذي يريد المستخدم الظهور به كمرسل
  /// [toEmail]: البريد الذي سيستلم الرسالة
  /// [message]: نصّ الترانسكربشن أو أي نص ترغبين بإرساله
  static Future<bool> sendEmail({
    required String fromEmail,
    required String toEmail,
    required String message,
  }) async {
    const String _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';

    // القيم التي ستُمرّر إلى قالب الإيميل في EmailJS
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
      final http.Response response = await http.post(
        Uri.parse(_emailJsUrl),
        headers: {
          'origin':
          'http://localhost', // غالبًا EmailJS يطلب أن يكون origin هكذا
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // إذا عاد 200 => تم الإرسال بنجاح
      if (response.statusCode == 200) {
        return true;
      } else {
        print('EmailJS error: ${response.statusCode} – ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception sending email: $e');
      return false;
    }
  }
}