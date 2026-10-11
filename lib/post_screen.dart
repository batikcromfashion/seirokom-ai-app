import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> sendPostToFacebook(String messageText) async {
    if (messageText.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('https://seirokom-ai-backend.onrender.com/facebook/post');
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": messageText}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('সফলভাবে ফেসবুক পেজে পোস্ট করা হয়েছে!')),
        );
        _messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('পোস্ট করতে ব্যর্থ হয়েছে: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('কানেকশন এরর: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SeiRokom AI - Facebook Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'আপনি কী পোস্ট করতে চান তা এখানে লিখুন...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => sendPostToFacebook(_messageController.text),
                    child: Text('ফেসবুক পেজে পোস্ট করুন'),
                  ),
          ],
        ),
      ),
    );
  }
}
