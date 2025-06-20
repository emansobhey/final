import 'package:flutter/material.dart';
import '../../../../core/helpers/searchKnowledgeBase.dart';
class AskQuestionPage extends StatefulWidget {
  @override
  _AskQuestionPageState createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final TextEditingController _controller = TextEditingController();
  String? _answer;
  bool _loading = false;
  String? _error;

  void _sendQuestion() async {
    final question = _controller.text.trim();
    if (question.isEmpty) {
      setState(() {
        _error = "Please enter a question.";
        _answer = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _answer = null;
    });

    try {
      final answer = await askQuestion(question);
      setState(() {
        _answer = answer;
      });
    } catch (e) {
      setState(() {
        _error = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ask a Question")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Your Question",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading ? null : _sendQuestion,
                child: _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Ask"),
              ),
              SizedBox(height: 20),
              if (_error != null) ...[
                Text(_error!, style: TextStyle(color: Colors.red)),
              ] else if (_answer != null) ...[
                Text(
                  "Answer:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(_answer!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
