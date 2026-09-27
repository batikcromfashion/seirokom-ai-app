import 'package:flutter/material.dart';
import 'size_calculator_screen.dart';
import 'order_tracking_screen.dart';
import 'admin_add_product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> products = const [
    {
      'title': ' প্রিমিয়াম সিল্ক বাটিক শার্ট',
      'price': '৳ ২৫০০',
      'image': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500&q=80',
    },
    {
      'title': 'এক্সক্লুসিভ কটন বাটিক শার্ট',
      'price': '৳ ১৮০০',
      'image': 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SeiRokom Fashion', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business),
            tooltip: 'Add Product (Admin)',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminAddProductScreen()),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.shopping_bag_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Batik & Apparel Collection', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('ঐতিহ্য ও আধুনিকতার সেরা মেলবন্ধন', style: TextStyle(color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SizeCalculatorScreen()),
                      );
                    },
                    icon: const Icon(Icons.straighten, size: 18),
                    label: const Text('Size Calc'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade200),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderTrackingScreen()),
                      );
                    },
                    icon: const Icon(Icons.local_shipping, size: 18),
                    label: const Text('Track Order'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade200),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
