import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/cubit/transcription_cubit.dart';
import 'package:gradprj/views/home/ui/screens/recording_screen.dart';
import 'package:gradprj/views/home/ui/screens/note_page.dart'; // ✨ تأكدي إن المسار صح
import 'package:http_parser/http_parser.dart';

class BottomBarHome extends StatefulWidget {
  const BottomBarHome({super.key});

  @override
  State<BottomBarHome> createState() => _BottomBarHomeState();
}

class _BottomBarHomeState extends State<BottomBarHome> {
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
          builder: (context) => NotePage(content: transcription,),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<TranscriptionCubit>(),
                      child: const RecordingScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.mic,
                color: MyColors.button1Color,
                size: 45,
              ),
            ),
            horizontalSpace(20),
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: _isUploading ? null : _pickAndUploadAudio,
                  icon: const Icon(
                    Icons.file_upload_outlined,
                    color: MyColors.button1Color,
                    size: 45,
                  ),
                ),
                if (_isUploading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: MyColors.button1Color,
                      strokeWidth: 2,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
