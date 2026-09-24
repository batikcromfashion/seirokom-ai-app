import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seirokom AI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // Google AI Studio থেকে পাওয়া আপনার API Key
  final String apiKey = "AQ.Ab8RN6Iysp4nj1H9pZtVFw-cQ8z7QpQbx9T-W8J_qv2RHZQfJw";

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
      _isLoading = true;
    });

    _controller.clear();

    // Gemini Native REST API endpoint (URL এর সাথে key পাস করা হয়েছে)
    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": text}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiReply = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? "কোনো উত্তর পাওয়া যায়নি।";

        setState(() {
          _messages.add({"sender": "ai", "text": aiReply});
        });
      } else {
        setState(() {
          _messages.add({"sender": "ai", "text": "Error: ${response.statusCode} - ${response.body}"});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"sender": "ai", "text": "Connection failure: $e"});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seirokom AI Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      msg["text"] ?? "",
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "কিছু লিখুন...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
