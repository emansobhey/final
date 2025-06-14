import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../screens/emailService.dart';
class CustomDraggableScrollableSheet extends StatefulWidget {
  final String transcriptionText;

  const CustomDraggableScrollableSheet(
      {Key? key, required this.transcriptionText})
      : super(key: key);

  @override
  State<CustomDraggableScrollableSheet> createState() =>
      _CustomDraggableScrollableSheetState();
}

class _CustomDraggableScrollableSheetState
    extends State<CustomDraggableScrollableSheet> {
  bool _isEmailFormVisible = false;
  final GlobalKey screenshotKey = GlobalKey();

  final TextEditingController _fromEmailController = TextEditingController();
  final TextEditingController _toEmailController = TextEditingController();

  bool _isSending = false;
  @override
  void dispose() {
    _fromEmailController.dispose();
    _toEmailController.dispose();
    super.dispose();
  }

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

  Future<void> _sendEmail() async {
    final String fromEmail = _fromEmailController.text.trim();
    final String toEmail = _toEmailController.text.trim();
    final String message = widget.transcriptionText.trim();

    if (fromEmail.isEmpty || !fromEmail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your valid  email address.')),
      );
      return;
    }
    if (toEmail.isEmpty || !toEmail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid recipient email address.')),
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
        const SnackBar(content: Text('Email sent successfully!'
        )),
      );
      _fromEmailController.clear();
      _toEmailController.clear();
      _toggleEmailForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send the email. Please try again.'
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        DraggableScrollableSheet(
          initialChildSize: 0.12,
          minChildSize: 0.12,
          maxChildSize: 0.85,
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: _toggleEmailForm,
                      ),

                      IconButton(
                          icon: const Icon(Icons.image, color: Colors.white),
                          onPressed: () {
                            showImageSizeSelector(context);
                          }),

                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.transcriptionText),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Text copied!"
                            )),
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
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
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: Text("view transcript" ,style: TextStyle(fontSize: 12),),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                      ),
SizedBox(width: 10,),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.mic, color: Colors.white),
                        label: const Text("append to note",style: TextStyle(fontSize: 12),),
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
                        child: const Text("Summarizing",style: TextStyle(fontSize: 12),),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: const Text("detected topics",style:TextStyle(fontSize: 12),),
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed:_toggleEmailForm ,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child:  const Text(
                              'cancel',
                              style: TextStyle(fontSize: 16,color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isSending ? null : _sendEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
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
                              style: TextStyle(fontSize: 16,color: Colors.white),
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