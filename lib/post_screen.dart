import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  bool _isAiLoading = false;

  // AI দিয়ে ক্যাপশন সুন্দর করবে
  Future<void> _generateAiCaption() async {
    if (_messageController.text.isEmpty) {
      _messageController.text = "পাঞ্জাবি";
    }
    setState(() => _isAiLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    // Smart AI Caption
    String input = _messageController.text.toLowerCase();
    String aiCaption = "";
    if (input.contains("পাঞ্জাবি")) {
      aiCaption = "✨ সেইরকম ফ্যাশনে ঈদ কালেকশন চলে এসেছে! \n👕 প্রিমিয়াম পাঞ্জাবি মাত্র ১২০০৳ থেকে শুরু\n📦 সারা বাংলাদেশে হোম ডেলিভারি\n\nঅর্ডার করতে এখনই ইনবক্স করুন 🫶🇧🇩\n#SeiRokomFashion #PanjabiCollection #Eid2026";
    } else {
      aiCaption = "✨ ${ _messageController.text } - সেইরকম ফ্যাশনে নতুন কালেকশন!\n📦 সারা বাংলাদেশে হোম ডেলিভারি\n\nঅর্ডার করতে ইনবক্স করুন 🫶\n#SeiRokomFashion";
    }
    setState(() {
      _messageController.text = aiCaption;
      _isAiLoading = false;
    });
  }

  Future<void> sendPostToFacebook(String messageText) async {
    if (messageText.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse('https://seirokom-ai-backend.onrender.com/facebook/post');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "message": messageText,
          "page_id": "119701757791186" // My Name Is Sahidul Islam
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('আপনার ফেসবুক পেজে পোস্ট করা হয়েছে! ✅')));
        _messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('পোস্ট করতে ব্যর্থ হয়েছে: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('কানেকশন এরর: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // ডার্ক, সাদা না
      appBar: AppBar(title: const Text('AI Assistant - Sohidul Islam Page'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              maxLines: 6,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'আপনার কী পোস্ট করতে চান তা এখানে লিখুন...',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                onPressed: _generateAiCaption,
                child: _isAiLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('🤖 AI দিয়ে সুন্দর করো', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            _isLoading ? const CircularProgressIndicator() 
            : SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () => sendPostToFacebook(_messageController.text),
                child: const Text('📤 ফেসবুক পেজে পোস্ট করো', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10),
            const Text('পেইজ: My Name Is Sohidul Islam (119701757791186) + SeiRokom Fashion Assistant হিসাবে কাজ করবে', style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
