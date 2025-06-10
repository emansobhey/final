import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/custom_raised_gradientbutton.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/add_trallo.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with SingleTickerProviderStateMixin {
  late RecorderController recorderController;
  bool isRecording = false;
  String filePath = '';
  final String ipconfig ="192.168.1.102";
  int recordingSeconds = 0;
  Timer? _timer;
  String? transcription;
  List<String> extractedTasks = [];
  List<String> detectedTopics = [];
  bool showEnhancedPage = false;
  bool showTasks = false;
  bool showSsummarization = false;
  String? enhancedText;
  bool isEnhancing = false;
  String? enhanceError;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool isSummarizing = false;
  String? summaryText;
  String? summaryError;
  bool showTopics = false;
  String? topicsText;
  String? tasksText;
  bool isLoadingTopics = false;
  bool isLoadingTasks = false;
  String? topicsError;
  String? tasksError;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController()
      ..updateFrequency = const Duration(milliseconds: 100)
      ..sampleRate = 16000
      ..bitRate = 16000
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    startRecording();
  }

  @override
  void dispose() {
    stopTimer();
    recorderController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      filePath = '${dir.path}/recording.m4a';
      await recorderController.record(path: filePath);
      setState(() => isRecording = true);
      startTimer();
    } catch (e) {
      print("❌ Error starting recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      await recorderController.stop();
      stopTimer();
      setState(() {
        isRecording = false;
        showEnhancedPage = true;
      });
      await uploadAudio();
      await fetchEnhancedText();
      setState(() {
        _controller.forward(from: 0);
      });
    } catch (e) {
      print("❌ Error stopping recording: $e");
    }
  }

  Future<void> uploadAudio() async {
    if (filePath.isEmpty || !File(filePath).existsSync()) {
      print("❌ No valid file to upload");
      return;
    }
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          filePath,
          contentType: MediaType('audio', 'mpeg'),
        ),
      });

      Response response = await Dio().post(
        "http://$ipconfig:8000/transcribe/",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );
      print("Response Data: ${response.data}"); // ← أضف هذا السطر هنا
      setState(() {
        transcription = response.data["transcription"];
      });

      print("✅ Transcription: $transcription");
    } catch (e) {
      print("❌ Error uploading file: $e");
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
      if (response.statusCode == 200) {
        final data = response.data;

        // معالجة البيانات لو راجعة كنص يحتوي على سطور
        final rawTopics = data['topics'];
        if (rawTopics is String) {
          detectedTopics = rawTopics
              .split('\n')
              .map((t) => t.trim())
              .where((t) => t.isNotEmpty)
              .toList();
        } else if (rawTopics is List) {
          detectedTopics = List<String>.from(rawTopics);
        } else {
          topicsError = "Unexpected data format for topics.";
        }
      } else {
        topicsError = "Failed to fetch topics.";
      }
    } catch (e) {
      topicsError = "Error: ${e.toString()}";
    } finally {
      setState(() {
        isLoadingTopics = false;
      });
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
      if (response.statusCode == 200) {
        final data = response.data;
        // تقسيم المهام إلى قائمة باستخدام new line
        extractedTasks = (data['tasks'] as String)
            .split('\n')
            .where((task) => task.trim().isNotEmpty)
            .toList();
      } else {
        tasksError = "Failed to fetch tasks.";
      }
    } catch (e) {
      tasksError = "Error: ${e.toString()}";
    } finally {
      setState(() {
        isLoadingTasks = false;
      });
    }
  }

  Future<void> fetchEnhancedText() async {
    setState(() {
      isEnhancing = true;
      enhanceError = null;
    });

    final dio = Dio();
    final url =
        'http://$ipconfig:8000/enhance/'; // غيّري IP لو بتجربي على جهاز حقيقي

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          enhancedText = response.data['enhanced_text'];
          isEnhancing = false;
        });
      } else {
        setState(() {
          enhanceError =
              "Failed to enhance text. Status: ${response.statusCode}";
          isEnhancing = false;
        });
      }
    } catch (e) {
      setState(() {
        enhanceError = "Error: $e";
        isEnhancing = false;
      });
    }
  }

  Future<void> fetchSummary() async {
    setState(() {
      isSummarizing = true;
      summaryError = null;
    });

    final dio = Dio();
    final url =
        'http://$ipconfig:8000/summarize/'; // غيّري IP لو بتجربي على موبايل حقيقي

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          summaryText = response.data['summary'];
          isSummarizing = false;
        });
      } else {
        setState(() {
          summaryError =
              "Failed to summarize text. Status: ${response.statusCode}";
          isSummarizing = false;
        });
      }
    } catch (e) {
      setState(() {
        summaryError = "Error: $e";
        isSummarizing = false;
      });
    }
  }

  void startTimer() {
    recordingSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          recordingSeconds++;
        });
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    if (showEnhancedPage) {
      return Scaffold(
        backgroundColor: MyColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: MyColors.backgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset("assets/images/arrow.png", width: 35, height: 35),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(' Original Text:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [MyColors.button1Color, MyColors.button2Color],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: transcription == null || transcription!.isEmpty
                      ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      :Text(
                    transcription !,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(' Enhanced Text:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              MyColors.button1Color,
                              MyColors.button2Color
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: isEnhancing
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : enhanceError != null
                                ? Text(enhanceError!,
                                    style: const TextStyle(
                                        color: MyColors.whiteColor))
                                : Text(
                                    enhancedText ??
                                        "No enhanced text available.",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: MyColors.whiteColor),
                                  ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomRaisedGradientButton(
                            width: 130,
                            onPressed: () async {
                              await fetchTasks();
                              setState(() {
                                showTasks = !showTasks;
                              });
                            },
                            text: 'Extracted Tasks'),
                        CustomRaisedGradientButton(
                            width: 130,
                            onPressed: () async {
                              await fetchSummary();
                              setState(() {
                                showSsummarization = !showSsummarization;
                              });
                            },
                            text: 'Summarization'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomRaisedGradientButton(
                          width: 130,
                          onPressed: () {
                            addTasksToTrello(
                              boardName: "graguation project",
                              listName: "try",
                              context: context,
                            );
                          },
                          text: 'Add to trello',
                        ),

                        CustomRaisedGradientButton(
                            width: 130,
                            onPressed: () async {
                              await fetchTopics();
                              setState(() {
                                showTopics = !showTopics;
                              });
                            },
                            text: 'Detect Topics'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (showSsummarization) ...[
                      if (summaryText != null ||
                          isSummarizing ||
                          summaryError != null)
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(' Summary:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      MyColors.button1Color,
                                      MyColors.button2Color,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: isSummarizing
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white))
                                    : summaryError != null
                                        ? Text(summaryError!,
                                            style: const TextStyle(
                                                color: Colors.white))
                                        : Text(
                                            summaryText ??
                                                "No summary available.",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                              ),
                            ],
                          ),
                        ),
                    ]
                  ],
                ),
                const SizedBox(height: 20),
                if (showTopics) ...[
                  const Text(
                    ' Detected Topics:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...detectedTopics.map(
                    (topic) => Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              MyColors.button1Color,
                              MyColors.button2Color,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.topic, color: Colors.white),
                          title: Text(
                            topic,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (showTasks) ...[
                  const Text(' Extracted Tasks:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 16),
                  ...extractedTasks.map((task) => Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                MyColors.button1Color,
                                MyColors.button2Color,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.check_circle_outline,
                                color: Colors.white),
                            title: Text(
                              task,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ))
                ]
              ],
            ),
          ),
        ),
      );
    }

    String timerText =
        "${(recordingSeconds ~/ 60).toString().padLeft(2, '0')}:${(recordingSeconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Spokify",
                style: MyFontStyle.font38Bold.copyWith(color: Colors.white)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [MyColors.button1Color, MyColors.button2Color],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Text(timerText,
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  AudioWaveforms(
                    enableGesture: false,
                    size: const Size(300, 50),
                    recorderController: recorderController,
                    waveStyle: const WaveStyle(
                      waveColor: Colors.white,
                      extendWaveform: true,
                      showMiddleLine: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () => startRecording(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => stopRecording(),
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColors.button1Color, MyColors.button2Color],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                    child: Icon(Icons.stop, color: Colors.white, size: 35)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}









