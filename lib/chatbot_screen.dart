import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'হ্যালো! SeiRokom Fashion AI অ্যাসিস্ট্যান্টে স্বাগতম। কীভাবে সাহায্য করতে পারি?'
    }
  ];

  bool _isLoading = false;

  // console.groq.com/keys থেকে নেওয়া আপনার আসল Groq API Key দিন (gsk_ দিয়ে শুরু হয়)
  static const String _apiKey = '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';

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userText = _controller.text;
    setState(() {
      _messages.add({'sender': 'user', 'text': userText});
      _controller.clear();
      _isLoading = true;
    });

    try {
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

      final systemPrompt =
          'You are a helpful AI sales assistant for "SeiRokom Fashion", a clothing brand specializing in Batik Shirts in Bangladesh. Always answer in polite Bengali.';

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'openai/gpt-oss-120b',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userText},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final aiText = data['choices']?[0]['message']?['content'];
        _addAiMessage(aiText ?? 'দুঃখিত, কোনো উত্তর পাওয়া যায়নি।');
      } else {
        final errorData = jsonDecode(utf8.decode(response.bodyBytes));
        _addAiMessage('API Error (${response.statusCode}):\n${errorData['error']?['message'] ?? response.body}');
      }
    } catch (e) {
      _addAiMessage('Connection Error:\n${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addAiMessage(String text) {
    if (mounted) {
      setState(() {
        _messages.add({'sender': 'ai', 'text': text});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Sales Assistant', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUser = _messages[index]['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.amber.shade200 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _messages[index]['text'] ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(color: Colors.amber),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'এখানে লিখুন...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.amber),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
