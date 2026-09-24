import 'package:flutter/material.dart';

class TryOnScreen extends StatefulWidget {
  const TryOnScreen({Key? key}) : super(key: key);

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  bool _isProcessing = false;

  void _simulateAiFitting() {
    setState(() {
      _isProcessing = true;
    });

    // AI প্রসেসিং সিমুলেশন
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI ট্রাই-অন প্রসেস সম্পন্ন হয়েছে!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Virtual Try-On'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: _isProcessing
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(color: Colors.amber),
                        SizedBox(height: 15),
                        Text('AI দিয়ে ফিটিং ম্যাচ করা হচ্ছে...'),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text('আপনার বা মডেলের ছবি নির্বাচন করুন'),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _simulateAiFitting,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('ছবি আপলোড করুন ও ট্রাই করুন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
