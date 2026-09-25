import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> products = const [
    {
      'title': 'প্রিমিয়াম ব্লু বাটিক শার্ট',
      'price': '৳ ১২৫০',
      'image': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500&q=80',
    },
    {
      'title': 'এক্সক্লুসিভ রেড বাটিক শার্ট',
      'price': '৳ ১৩৫০',
      'image': 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500&q=80',
    },
    {
      'title': 'ক্লাসিক ব্ল্যাক বাটিক শার্ট',
      'price': '৳ ১১৫০',
      'image': 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&q=80',
    },
    {
      'title': 'রয়েল প্রিমিয়াম বাটিক',
      'price': '৳ ১৪৫০',
      'image': 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SeiRokom Fashion', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        actions: [
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
            const SizedBox(height: 20),
            const Text('আমাদের এক্সক্লুসিভ কালেকশন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            product['image']!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: Colors.grey.shade300, child: const Icon(Icons.image_not_supported)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(product['price']!, style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
