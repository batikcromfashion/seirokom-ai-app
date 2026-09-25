import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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

  // তোমার পাঠানো API Key টি এখানে বসিয়ে দেওয়া হয়েছে
  static const String _apiKey = 'AQ.Ab8RN6I1xzqXu4C5KNqIb_NrAtIao7PgU5yqKgk9cyQasupPdw';

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userText = _controller.text;
    setState(() {
      _messages.add({'sender': 'user', 'text': userText});
      _controller.clear();
      _isLoading = true;
    });

    try {
      if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE' || _apiKey.isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        _addAiMessage(_getFallbackResponse(userText));
      } else {
        // সরাসরি Gemini AI মডেল কল করা হচ্ছে
        final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
        final prompt = 'You are a helpful AI sales assistant for "SeiRokom Fashion", a clothing brand specializing in Batik Shirts in Bangladesh. Answer in polite Bengali. Question: $userText';
        final response = await model.generateContent([Content.text(prompt)]);

        _addAiMessage(response.text ?? 'দুঃখিত, পুনরায় চেষ্টা করুন।');
      }
    } catch (e) {
      // কোনো কারণে এরর আসলে ডামি উত্তর দেবে
      _addAiMessage(_getFallbackResponse(userText));
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

  // AI কাজ না করলে বা অফলাইনে থাকলে এই উত্তরগুলো দেবে
  String _getFallbackResponse(String query) {
    String q = query.toLowerCase();
    if (q.contains('সাইজ') || q.contains('size')) {
      return 'আমাদের প্রিমিয়াম বাটিক শার্ট M, L, XL এবং XXL সাইজে অ্যাভেইলএবল রয়েছে।';
    } else if (q.contains('দাম') || q.contains('price')) {
      return 'আমাদের প্রিমিয়াম বাটিক শার্টের দাম ৮৫০ টাকা থেকে শুরু।';
    } else if (q.contains('ডেলিভারি')) {
      return 'ঢাকার ভেতরে ডেলিভারি চার্জ ৮০ টাকা এবং ঢাকার বাইরে ১৫০ টাকা।';
    }
    return 'SeiRokom Fashion-এ আপনাকে স্বাগতম! আরও তথ্যের জন্য আমাদের সাথে থাকুন।';
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
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.amber.shade200 : Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft: isUser ? const Radius.circular(15) : const Radius.circular(0),
                        bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      _messages[index]['text'] ?? '',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(color: Colors.amber),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'এখানে লিখুন...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
