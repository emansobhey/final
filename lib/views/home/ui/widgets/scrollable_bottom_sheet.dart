import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../screens/emailService.dart';
class CustomDraggableScrollableSheet extends StatefulWidget {
  final String transcriptionText;

  /// لنفترض أن `transcriptionText` هو النص الذي تم تفريغه (مثلاً من Gemini أو غيره).
  const CustomDraggableScrollableSheet(
      {Key? key, required this.transcriptionText})
      : super(key: key);

  @override
  State<CustomDraggableScrollableSheet> createState() =>
      _CustomDraggableScrollableSheetState();
}

class _CustomDraggableScrollableSheetState
    extends State<CustomDraggableScrollableSheet> {
  // فتح/إغلاق نموذج الإيميل
  bool _isEmailFormVisible = false;
  final GlobalKey screenshotKey = GlobalKey();

  // متحكّمات (Controllers) حقول النص
  final TextEditingController _fromEmailController = TextEditingController();
  final TextEditingController _toEmailController = TextEditingController();

  bool _isSending = false; // حالة الإرسال قيد المعالجة

  @override
  void dispose() {
    _fromEmailController.dispose();
    _toEmailController.dispose();
    super.dispose();
  }

  /// دالة لعرض/إخفاء نموذج الإيميل (Bottom Modal)
  void _toggleEmailForm() {
    setState(() {
      _isEmailFormVisible = !_isEmailFormVisible;
    });
  }

  void showImageSizeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2E3244),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Create a shareable image",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _sizeOption(context, 200, 300, "Small", 60, 90),
                  _sizeOption(context, 300, 400, "Medium", 80, 120),
                  _sizeOption(context, 400, 500, "Large", 100, 150),
                ],
              ),
              // const SizedBox(height: 20),
              // const Text("Great for LinkedIn posts.",
              //     style: TextStyle(color: Colors.white70)),
            ],
          ),
        );
      },
    );
  }

  Widget _sizeOption(
      BuildContext context,
      double imgWidth,
      double imgHeight,
      String label,
      double boxWidth,
      double boxHeight,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        createImageFromText(context, imgWidth, imgHeight);
      },
      child: Container(
        width: boxWidth,
        height: boxHeight,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white30),
        ),
        child: Center(
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void createImageFromText(
      BuildContext context, double width, double height) async {
    final controller = ScreenshotController();

    final imageWidget = Screenshot(
      controller: controller,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFF2E3244),
        ),
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.transcriptionText,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            softWrap: true,
          ),
        ),
      ),
    );

    final imageBytes = await controller.captureFromWidget(imageWidget);

    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/transcription_image.png';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageBytes);

    Share.shareXFiles(
      [XFile(imagePath)],
      //text: 'Here’s the transcription image!'
    );
  }

  /// دالة حقيقية لإرسال البريد عندما يضغط المستخدم زر Send
  Future<void> _sendEmail() async {
    final String fromEmail = _fromEmailController.text.trim();
    final String toEmail = _toEmailController.text.trim();
    final String message = widget.transcriptionText.trim();

    // تحقق بسيط من صحة الإيميلات
    if (fromEmail.isEmpty || !fromEmail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك أدخل بريد مرسل صحيح')),
      );
      return;
    }
    if (toEmail.isEmpty || !toEmail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك أدخل بريد مستقبل صحيح')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    final bool success = await EmailService.sendEmail(
      fromEmail: fromEmail,
      toEmail: toEmail,
      message: message,
    );

    setState(() {
      _isSending = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال الإيميل بنجاح!')),
      );
      // بعد الإرسال، ننظف الحقول ونغلق النموذج
      _fromEmailController.clear();
      _toEmailController.clear();
      _toggleEmailForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في إرسال الإيميل. حاول مرة أخرى.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية (يمكن إضافة المحتوى الأصلي هنا إذا كان موجود)
        // ... (محتوى الخلفية إذا رغبتِ)

        // هذا هو الـ DraggableScrollableShee
        DraggableScrollableSheet(
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
                  // المقبض الصغير
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

                  // صف الأيقونات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // أيقونة المشاركة (Share)
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: _toggleEmailForm,
                      ),

                      // أيقونة الصورة (مثال)
                      IconButton(
                          icon: const Icon(Icons.image, color: Colors.white),
                          onPressed: () {
                            showImageSizeSelector(context);
                          }),

                      // أيقونة النسخ (Copy)
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white),
                        onPressed: () {
                          // نسخ النص إلى الحافظة (Clipboard)
                          Clipboard.setData(
                            ClipboardData(text: widget.transcriptionText),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم نسخ النص!')),
                          );
                        },
                      ),

                      // أيقونة الحذف (Delete)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          // وظيفة الحذف
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  verticalSpace(20),
                  const Center(
                    child: Text(
                      "+ add tags",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  verticalSpace(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: Text("view transcript"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.mic, color: Colors.white),
                        label: const Text("append to note"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Summarizing"),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: const Text("detected topics"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),

        // ----------------------------------------------
        // هذا الجزء هو نموذج الإيميل (Email Form) المُتظاهر فوق الـ Bottom Sheet
        // ----------------------------------------------
        if (_isEmailFormVisible)
          Container(
            color: Colors.black.withOpacity(0.5), // خلفية شفافة
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3244),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // عنوان النموذج
                      const Text(
                        'Send Transcription via Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // حقل From Email
                      TextField(
                        controller: _fromEmailController,
                        decoration: InputDecoration(
                          hintText: 'Your Email (from)',
                          hintStyle: TextStyle(color: Colors.white54),
                          fillColor: const Color(0xFF3A3F55),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 12),

                      // حقل To Email
                      TextField(
                        controller: _toEmailController,
                        decoration: InputDecoration(
                          hintText: 'Recipient Email (to)',
                          hintStyle: TextStyle(color: Colors.white54),
                          fillColor: const Color(0xFF3A3F55),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 12),

                      // نصّ الترانسكربشن (لعرضه فقط، وليس للتعديل)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A3F55),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.transcriptionText,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // صف الأزرار: Send و Cancel
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // زر إلغاء و إغلاق النموذج
                          TextButton(
                            onPressed: _toggleEmailForm,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),

                          // زر الإرسال
                          ElevatedButton(
                            onPressed: _isSending ? null : _sendEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isSending
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'Send',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}