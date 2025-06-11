import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/views/home/ui/widgets/transcription_container.dart';
import 'package:gradprj/views/home/ui/widgets/enhanced_text_container.dart';
import 'package:gradprj/views/home/ui/widgets/summary_container.dart';
import 'package:gradprj/views/home/ui/widgets/topics_list.dart';
import 'package:gradprj/views/home/ui/widgets/tasks_list.dart';
import 'package:gradprj/views/home/ui/widgets/action_buttons_row.dart';

import '../widgets/add_trallo.dart';

class TextProcessingScreen extends StatefulWidget {
  final String transcription;

  const TextProcessingScreen({super.key, required this.transcription});

  @override
  State<TextProcessingScreen> createState() => _TextProcessingScreenState();
}

class _TextProcessingScreenState extends State<TextProcessingScreen> {
  String ipconfig = "192.168.1.102";

  String enhancedText = '';
  String summaryText = '';
  List<String> detectedTopics = [];
  List<String> extractedTasks = [];

  bool isEnhancing = false;
  bool isSummarizing = false;
  bool isLoadingTopics = false;
  bool isLoadingTasks = false;

  String? enhanceError;
  String? summaryError;
  String? topicsError;
  String? tasksError;

  bool showTasks = false;
  bool showTopics = false;
  bool showSsummarization = false;

  @override
  void initState() {
    super.initState();
    fetchEnhancedText();
  }

  Future<void> fetchEnhancedText() async {
    setState(() {
      isEnhancing = true;
      enhanceError = null;
    });

    try {
      final response = await Dio().get('http://$ipconfig:8000/enhance/');
      if (response.statusCode == 200) {
        print("✅ Enhanced Response: ${response.data}");
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

  Future<void> fetchSummary() async {
    setState(() {
      isSummarizing = true;
      summaryError = null;
    });

    try {
      final response = await Dio().get('http://$ipconfig:8000/summarize/');
      if (response.statusCode == 200) {
        setState(() => summaryText = response.data['summary']);
      } else {
        summaryError = "Failed to summarize.";
      }
    } catch (e) {
      summaryError = "Summary Error: $e";
    } finally {
      setState(() => isSummarizing = false);
    }
  }

  Future<void> fetchTopics() async {
    setState(() {
      isLoadingTopics = true;
      topicsError = null;
      detectedTopics.clear();
    });

    try {
      final response = await Dio().get('http://$ipconfig:8000/detect_topics/');
      final rawTopics = response.data['topics'];

      if (rawTopics is String) {
        detectedTopics = rawTopics.split('\n').where((t) => t.trim().isNotEmpty).toList();
      } else if (rawTopics is List) {
        detectedTopics = List<String>.from(rawTopics);
      } else {
        topicsError = "Invalid topics format.";
      }
    } catch (e) {
      topicsError = "Topics Error: $e";
    } finally {
      setState(() => isLoadingTopics = false);
    }
  }

  Future<void> fetchTasks() async {
    setState(() {
      isLoadingTasks = true;
      tasksError = null;
      extractedTasks.clear();
    });

    try {
      final response = await Dio().get('http://$ipconfig:8000/extract_tasks/');
      extractedTasks = (response.data['tasks'] as String)
          .split('\n')
          .where((task) => task.trim().isNotEmpty)
          .toList();
    } catch (e) {
      tasksError = "Tasks Error: $e";
    } finally {
      setState(() => isLoadingTasks = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundColor,
        leading: IconButton(
          icon: Image.asset("assets/images/arrow.png", width: 35, height: 35),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranscriptionContainer(transcription: widget.transcription),
              const SizedBox(height: 30),
              EnhancedTextContainer(
                enhancedText: enhancedText,
                isEnhancing: isEnhancing,
                enhanceError: enhanceError,
              ),
              const SizedBox(height: 30),
              ActionButtonsRow(
                onFetchTasks: () async {
                  await fetchTasks();
                  setState(() => showTasks = !showTasks);
                },
                onFetchSummary: () async {
                  await fetchSummary();
                  setState(() => showSsummarization = !showSsummarization);
                },
                onFetchTopics: () async {
                  await fetchTopics();
                  setState(() => showTopics = !showTopics);
                },
                onTrelloPressed: () => showTrelloInputDialog(context),
              ),
              const SizedBox(height: 30),
              if (showSsummarization)
                SummaryContainer(
                  summaryText: summaryText,
                  isSummarizing: isSummarizing,
                  summaryError: summaryError,
                ),
              if (showTopics)
                TopicsList(topics: detectedTopics),
              if (showTasks)
                TasksList(tasks: extractedTasks),
            ],
          ),
        ),
      ),
    );
  }
}
