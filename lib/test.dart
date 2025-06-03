// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'dart:convert';
//
// class QuestionPage extends StatefulWidget {
//   @override
//   _QuestionPageState createState() => _QuestionPageState();
// }
//
// class _QuestionPageState extends State<QuestionPage> {
//   TextEditingController _questionController = TextEditingController();
//   String answer = '';
//   String relatedParagraphs = '';
//   Future<void> askQuestion() async {
//     final String question = _questionController.text.trim();
//     if (question.isEmpty) return;
//
//     try {
//       final dio = Dio();
//
//       final response = await dio.post(
//         "http://192.168.1.25:8000/ask_question/",
//         data: {
//           "question": question, // إرسال السؤال في جسم الـ JSON
//         },
//         options: Options(
//           headers: {
//             "Content-Type": "application/json",
//           },
//         ),
//       );
//
//       setState(() {
//         answer = response.data["answer"] ?? "لا يوجد رد.";
//         relatedParagraphs = response.data["related_paragraphs"] ?? "";
//       });
//     } catch (e) {
//       print("❌ Error: $e");
//       setState(() {
//         answer = "❌ حصل خطأ أثناء إرسال السؤال.";
//         relatedParagraphs = "";
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('اسأل سؤال')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _questionController,
//               decoration: InputDecoration(
//                 hintText: 'أدخل سؤالك هنا...',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: askQuestion,
//               child: Text('إرسال'),
//             ),
//             SizedBox(height: 20),
//             Text('الإجابة: $answer'),
//             SizedBox(height: 10),
//             Text('فقرات ذات صلة:'),
//             Text(relatedParagraphs),
//           ],
//         ),
//       ),
//     );
//   }
// }
















import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Upload & Transcription',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isUploading = false;
  String _transcription = "";

  Future<void> _pickAndUploadAudio() async {
    // اختر ملف صوتي
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav', 'mp3', 'ogg', 'webm', 'opus'],
    );

    if (result == null) return; // المستخدم ألغى الاختيار

    String? filePath = result.files.single.path;
    if (filePath == null) return;

    File audioFile = File(filePath);

    setState(() {
      _isUploading = true;
    });

    try {
      // جهز ملف الرفع مع نوع الميديا حسب الامتداد
      String extension = audioFile.path.split('.').last.toLowerCase();
      String subtype;
      switch (extension) {
        case 'mp3':
          subtype = 'mpeg';
          break;
        case 'wav':
          subtype = 'wav';
          break;
        case 'ogg':
          subtype = 'ogg';
          break;
        case 'webm':
          subtype = 'webm';
          break;
        case 'opus':
          subtype = 'opus';
          break;
        default:
          subtype = 'mpeg';
      }

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split(Platform.pathSeparator).last,
          contentType: MediaType('audio', subtype),
        ),
      });

      // ارسل الملف للسيرفر
      String url = "http://192.168.1.102:8000/transcribe/"; // عدّل حسب عنوان سيرفرك
      Response response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      print("Response Data: ${response.data}");

      // استخرج النص المفرغ من الرد (تأكد من المفتاح في رد سيرفرك)
      String transcription = response.data["transcription"] ?? "لا يوجد نص";

      print("✅ Transcription: $transcription");

      setState(() {
        _transcription = transcription;
      });

      // انتقل لصفحة NotePage مع النص
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotePage(transcribedText: transcription),
        ),
      );
    } catch (e) {
      print("❌ Error uploading file: $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("خطأ"),
          content: Text("حدث خطأ أثناء رفع الملف: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("حسناً"),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('رفع ملف صوتي وتحويله لنص'),
      ),
      body: Center(
        child: _isUploading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
          icon: const Icon(Icons.file_upload_outlined),
          label: const Text('اختر و ارفع ملف صوت'),
          onPressed: _pickAndUploadAudio,
        ),
      ),
    );
  }
}

class NotePage extends StatelessWidget {
  final String transcribedText;

  const NotePage({super.key, required this.transcribedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفريغ النص'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            transcribedText,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}


























