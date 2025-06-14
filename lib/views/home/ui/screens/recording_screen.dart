import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/theming/my_colors.dart';
import '../../../../core/theming/my_fonts.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/enhanced_text_container.dart';
import '../widgets/recording_controls.dart';
import '../widgets/recording_waveform.dart';
import '../widgets/summary_container.dart';
import '../widgets/tasks_list.dart';
import '../widgets/topics_list.dart';
import '../widgets/top_bar.dart';
import '../widgets/transcription_container.dart';
import '../widgets/add_trallo.dart';
import 'TrelloTokenScreen.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> with SingleTickerProviderStateMixin {
  late RecorderController recorderController;
  bool isRecording = false;
  String filePath = '';
  final String ipconfig = "192.168.1.102";
  int recordingSeconds = 0;
  Timer? _timer;
  String? transcription;
  String? enhancedText;
  String? summaryText;
  List<String> detectedTopics = [];
  List<String> extractedTasks = [];

  bool showEnhancedPage = false;
  bool showSsummarization = false;
  bool showTopics = false;
  bool showTasks = false;

  bool isEnhancing = false;
  bool isSummarizing = false;
  bool isLoadingTopics = false;
  bool isLoadingTasks = false;

  String? enhanceError;
  String? summaryError;
  String? topicsError;
  String? tasksError;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController()
      ..updateFrequency = const Duration(milliseconds: 100)
      ..sampleRate = 16000
      ..bitRate = 16000
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4;

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    startRecording();
  }

  @override
  void dispose() {
    recorderController.dispose();
    _controller.dispose();
    stopTimer();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      filePath = '${dir.path}/recording.m4a';
      await recorderController.record(path: filePath);
      setState(() {
        isRecording = true;
        recordingSeconds = 0;
      });
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
      _controller.forward(from: 0);
    } catch (e) {
      print("❌ Error stopping recording: $e");
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => recordingSeconds++);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> uploadAudio() async {
    if (filePath.isEmpty || !File(filePath).existsSync()) return;

    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          filePath,
          contentType: MediaType('audio', 'mpeg'),
        ),
      });

      final response = await Dio().post(
        "http://$ipconfig:8000/transcribe/",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      setState(() => transcription = response.data["transcription"]);
    } catch (e) {
      print("❌ Upload error: $e");
    }
  }

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
  Future<void> refreshRecording() async {
    try {
      recorderController.reset();
      await recorderController.stop();
      stopTimer();                      // ⏹️ إيقاف المؤقت القديم

      final dir = await getApplicationDocumentsDirectory();
      filePath = '${dir.path}/recording.m4a'; // ⚠️ اختيار نفس الاسم أو اسم جديد لو تحبي

      await recorderController.record(path: filePath); // 🎙️ تسجيل جديد
      setState(() {
        recordingSeconds = 0;
        isRecording = true;
      });
      startTimer(); // 🕒 بدء المؤقت من جديد
    } catch (e) {
      print("❌ Error refreshing recording: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showEnhancedPage) {
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
                TranscriptionContainer(transcription: transcription),
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
                    onTrelloPressed: () async {
                      final token = await getTrelloToken();
                      if (token == null || token.isEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TrelloTokenScreen()),
                        );
                      } else {
                        showTrelloInputDialog(context);
                      }
                    }

                ),
                const SizedBox(height: 30),
                if (showSsummarization)
                  SummaryContainer(
                    summaryText: summaryText,
                    isSummarizing: isSummarizing,
                    summaryError: summaryError,
                  ),
                if (showTopics)
                  TopicsList(
                    topics: detectedTopics,
                  ),
                if (showTasks)
                  TasksList(
                    tasks: extractedTasks,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Spokify",
                style: MyFontStyle.font38Bold.copyWith(color: Colors.white)),
            const SizedBox(height: 20),
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
                  Text(
                    "${(recordingSeconds ~/ 60).toString().padLeft(2, '0')}:${(recordingSeconds % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  RecordingWaveform( recorderController: recorderController,),
                  const SizedBox(height: 20),
                  RecordingControls(
                    onClose: () => Navigator.pop(context),
                    refreshRecording:refreshRecording
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: stopRecording,
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [MyColors.button1Color, MyColors.button2Color]),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.stop, color: Colors.white, size: 35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
