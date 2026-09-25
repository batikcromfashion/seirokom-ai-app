import 'package:flutter/material.dart';

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
      'text': 'হ্যালো! SeiRokom Fashion-এ স্বাগতম। সাইজ, দাম বা প্রোডাক্ট বিষয়ে কোনো প্রশ্ন থাকলে বলুন!'
    }
  ];

  // ইউজার কী লিখছে তার ওপর ভিত্তি করে বুদ্ধিমান উত্তর তৈরি করার ফাংশন
  String _getAIResponse(String query) {
    String lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('সাইজ') || lowerQuery.contains('size') || lowerQuery.contains('মাপ')) {
      return 'আমাদের প্রিমিয়াম বাটিক শার্ট M, L, XL এবং XXL সাইজে অ্যাভেইলএবল রয়েছে। আপনার বুক ও লম্বা পরিমাপ অনুযায়ী সাইজ নির্বাচন করতে পারেন।';
    } else if (lowerQuery.contains('দাম') || lowerQuery.contains('price') || lowerQuery.contains('টাকা') || lowerQuery.contains('কত')) {
      return 'আমাদের প্রিমিয়াম বাটিক শার্টের দাম ৮৫০ টাকা থেকে শুরু। বিস্তারিত জানতে হোমপেজের প্রোডাক্টগুলো দেখুন।';
    } else if (lowerQuery.contains('ডেলিভারি') || lowerQuery.contains('delivery') || lowerQuery.contains('চার্জ')) {
      return 'ঢাকার ভেতরে ডেলিভারি চার্জ ৮০ টাকা এবং ঢাকার বাইরে ১৫০ টাকা। সাধারণত ২-৩ দিনের মধ্যে ডেলিভারি করা হয়।';
    } else if (lowerQuery.contains('কাপড়') || lowerQuery.contains('মেটেরিয়াল') || lowerQuery.contains('fabric') || lowerQuery.contains('সুতি')) {
      return 'আমাদের সব বাটিক শার্ট ১০০% প্রিমিয়াম কটন (সুতি) কাপড়ে তৈরি, যা অত্যন্ত আরামদায়ক।';
    } else if (lowerQuery.contains('হাই') || lowerQuery.contains('হ্যালো') || lowerQuery.contains('hello') || lowerQuery.contains('hi')) {
      return 'হ্যালো! আপনাকে কীভাবে সাহায্য করতে পারি?';
    } else {
      return 'ধন্যবাদ আপনার প্রশ্নের জন্য! প্রোডাক্টের সাইজ, দাম বা ডেলিভারি বিষয়ে বিস্তারিত জানতে আমাকে জিজ্ঞেস করতে পারেন।';
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    String userText = _controller.text;
    setState(() {
      _messages.add({'sender': 'user', 'text': userText});
      _controller.clear();
    });

    // ১ সেকেন্ড পর ডাইনামিক রিপ্লাই দেবে
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'ai',
            'text': _getAIResponse(userText)
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Sales Assistant'),
        backgroundColor: Colors.amber,
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
                    decoration: BoxDecoration(
                      color: isUser ? Colors.amber.shade200 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(_messages[index]['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
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
