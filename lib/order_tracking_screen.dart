import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final _orderController = TextEditingController();
  String _status = '';

  void _trackOrder() {
    if (_orderController.text.trim().isEmpty) return;
    
    // ডেমো অর্ডার টেস্ট
    setState(() {
      _status = 'অর্ডার স্ট্যাটাস: Processing (প্যাকেজিং চলছে)\nসম্ভাব্য ডেলিভারি: ২-৩ দিন';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking & Payment'), backgroundColor: Colors.amber),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _orderController,
              decoration: const InputDecoration(
                hintText: 'আপনার অর্ডার নম্বর দিন (যেমন: #SR102)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _trackOrder,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text('অর্ডার ট্র্যাক করুন', style: TextStyle(color: Colors.black)),
            ),
            if (_status.isNotEmpty) ...[
              const SizedBox(height: 20),
              Card(
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_status, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
