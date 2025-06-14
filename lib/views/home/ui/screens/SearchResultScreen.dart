import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import '../../../../core/helpers/searchKnowledgeBase.dart';

class AskQuestionPage extends StatefulWidget {
  @override
  _AskQuestionPageState createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final TextEditingController _controller = TextEditingController();
  String? _answer;
  String? _paragraphs;
  bool _loading = false;
  String? _error;

  void _sendQuestion() async {
    setState(() {
      _loading = true;
      _error = null;
      _answer = null;
      _paragraphs = null;
    });

    try {
      final result = await askQuestion(_controller.text);
      setState(() {
        _answer = result["answer"];
        _paragraphs = result["related_paragraphs"];
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildResultCard() {
    if (_loading) return const CircularProgressIndicator();
    if (_error != null) return Text("$_error");
    if (_answer == null) return const SizedBox();

    final paragraphs = _paragraphs!
        .split(RegExp(r'PARAGRAPH \d+:'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGlowCard(
          title: "answer:",
          content: _answer!,
        ),
        const SizedBox(height: 16),
        const Text("related_paragraphs🧾", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        ...paragraphs.map((p) => _buildParagraphCard(p)).toList(),
      ],
    );
  }

  Widget _buildGlowCard({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MyColors.button1Color.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildParagraphCard(String paragraph) {
    final preview = paragraph.split('\n').first;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: MyColors.button1Color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: MyColors.button2Color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          preview.length > 100 ? preview.substring(0, 100) + '...' : preview,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: MyColors.backgroundColor,
              title: const Text("All paragraph", style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(child: Text(paragraph, style: const TextStyle(color: Colors.white))),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("close"),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset("assets/images/arrow.png", width: 35, height: 35),
        ),
        title: const Text("search"),
        backgroundColor: MyColors.backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.button1Color),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.button2Color, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [MyColors.button1Color, MyColors.button2Color],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton.icon(
                  onPressed: _sendQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text("search", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
               _buildResultCard()
            ],
          ),
        ),
      ),
    );
  }
}
