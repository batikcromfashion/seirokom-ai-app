import 'package:flutter/material.dart';

class SizeCalculatorScreen extends StatefulWidget {
  const SizeCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<SizeCalculatorScreen> createState() => _SizeCalculatorScreenState();
}

class _SizeCalculatorScreenState extends State<SizeCalculatorScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _recommendedSize = '';

  void _calculateSize() {
    double? height = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_weightController.text);

    if (height == null || weight == null) return;

    setState(() {
      if (weight < 60) {
        _recommendedSize = 'S (Small)';
      } else if (weight >= 60 && weight < 70) {
        _recommendedSize = 'M (Medium)';
      } else if (weight >= 70 && weight < 80) {
        _recommendedSize = 'L (Large)';
      } else if (weight >= 80 && weight < 90) {
        _recommendedSize = 'XL (Extra Large)';
      } else {
        _recommendedSize = 'XXL (Custom Measurement Recommended)';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Size & Custom Tailoring'), backgroundColor: Colors.amber),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ভার্চুয়াল সাইজ রিকমেন্ডেশন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'আপনার উচ্চতা (ইঞ্চি/সেমি)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'আপনার ওজন (কেজি)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _calculateSize,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text('সাইজ দেখুন', style: TextStyle(color: Colors.black)),
            ),
            if (_recommendedSize.isNotEmpty) ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.amber.shade100,
                child: Text('আপনার জন্য সঠিক সাইজ: $_recommendedSize', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
            const Divider(height: 40),
            const Text('কাস্টম টেলরিং অর্ডার ফর্ম', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'বুকের মাপ (ইঞ্চি)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'লম্বা (ইঞ্চি)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'কাঁধের মাপ (ইঞ্চি)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('কাস্টম সাইজের তথ্য সেভ করা হয়েছে!')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('কাস্টম সাইজ নিশ্চিত করুন', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
