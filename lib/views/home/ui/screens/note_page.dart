import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/app_bar.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:gradprj/views/home/ui/widgets/custom_gustor_detector.dart';
import 'package:gradprj/views/home/ui/widgets/scrollable_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../core/helpers/fetchTranscriptionTitle(.dart';

class NotePage extends StatefulWidget {

   NotePage({super.key, });

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String title = "Loading...";
  String? enhanceError;
  bool isEnhancing = false; bool showEnhancedPage = false;  String? enhancedText;  final String ipconfig = "192.168.1.102";

  String formattedDate = DateFormat('MMM d, y').format(DateTime.now());
  bool _isLoadingTranscript = false;

  @override
  Future<void> fetchEnhancedText() async {
    setState(() {
      isEnhancing = true;
      enhanceError = null;
    });

    try {
      final response = await Dio().get('http://$ipconfig:8000/enhance/');
      if (response.statusCode == 200) {
        setState(() => enhancedText = response.data['enhanced_text']);
      } else {
        enhanceError = "Failed to enhance text.";
      }
    } catch (e) {
      enhanceError = "Enhance Error: $e";
    } finally {
      setState(() => isEnhancing = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTitle();
    fetchEnhancedText();
    fetchEnhancedText();
  }

  Future<void> _loadTitle() async {
    final fetchedTitle = await fetchTranscriptionTitle();
    if (fetchedTitle != null) {
      setState(() {
        title = fetchedTitle;
      });
    } else {
      setState(() {
        title = "No Title Found";
      });
    }
  }
  void _editText(String field) {
    TextEditingController controller = TextEditingController(
      text: field == 'title' ? title :enhancedText,
    );

    showDialogEdite(field, controller);
  }

  Future<dynamic> showDialogEdite(
      String field, TextEditingController controller) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: MyColors.backgroundColor,
        title: Text(
          "Edit ${field == 'title' ? 'Title' : 'Content'}",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          maxLines: field == 'title' ? 2 : 5,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: field == 'title' ? 'Enter title' : 'Enter content',
            hintStyle: const TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (field == 'title') {
                  title = controller.text;
                } else {
                  enhancedText= controller.text;
                }
              });
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: MyColors.button1Color),
            ),
          ),
        ],
      ),
    );
  }

  void _editBoth() {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController contentController = TextEditingController(text:enhancedText);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: MyColors.backgroundColor,
        title: const Text("Edit Note", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter title',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter content',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                title = titleController.text;
                enhancedText = contentController.text;
              });
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: MyColors.button1Color),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarOfSpokify(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: _editBoth,
                  ),
                  Center(
                    child: Text(
                      formattedDate,
                      style: MyFontStyle.font12RegularBtn.copyWith(color: MyColors.whiteColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomGestureDetector(
                    title: title,
                    onTap: () => _editText('title'),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 4,
                    width: 40,
                    color: MyColors.button2Color,
                  ),
                  verticalSpace(10),
                  _isLoadingTranscript
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.button1Color,
                    ),
                  )
                      :SingleChildScrollView(
                                                 child: GestureDetector(
                                                   onTap: () => _editText('content'),
                                                   child: Container(
                                                     padding: const EdgeInsets.all(16),
                                                     margin: const EdgeInsets.symmetric(
                                                         horizontal: 8, vertical: 8),
                                                     decoration: BoxDecoration(
                                                       color: MyColors.backgroundColor,
                                                       border: Border.all(color: Colors.grey.shade300),
                                                       borderRadius: BorderRadius.circular(12),
                                                       boxShadow: [
                                                         BoxShadow(
                                                           color: Colors.grey.shade300,
                                                           blurRadius: 6,
                                                           offset: const Offset(0, 3),
                                                         ),
                                                       ],
                                                     ),
                                                     child: Text(
                                                       enhancedText??"no",
                                                       style: const TextStyle(
                                                           fontSize: 16, color: Colors.white),
                                                     ),
                                                   ),
                                                 ),
                                               ),


                  SizedBox(height: MediaQuery.of(context).size.height * 0.111),
                ],
              ),
            ),
          ),
          CustomDraggableScrollableSheet(
            transcriptionText: enhancedText??"no",
          ),        ],
      ),
    );
  }
}
