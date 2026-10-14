import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chatbot_screen.dart';
import 'tryon_screen.dart';
import 'order_tracking_screen.dart';
import 'size_calculator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _launchWebsite() async {
    final Uri url = Uri.parse('https://batikcromfashion.github.io/SeiRokom-Fashion-/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // সাদা না, ডার্ক প্রফেশনাল
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SeiRokom Fashion',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('seirokomfashion.com',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('✨ Welcome To My SeiRokom Fashion',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('Thanks For Coming Here 🫶🇧🇩❤️',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text('স্টাইলের নতুন ঠিকানা',
                  style: TextStyle(color: Color(0xFFF472B6), fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 15),

              // Buttons Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildCard(context, '🌐 Website', 'ওয়েবসাইট দেখুন', Colors.blue, _launchWebsite),
                  _buildCard(context, '🤖 Ai Help Centre', 'চ্যাটবট', Colors.orange, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen()));
                  }),
                  _buildCard(context, '👕 Try-On', 'AI Virtual Try-On', Colors.purple, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TryOnScreen()));
                  }),
                  _buildCard(context, '📦 Order Track', 'অর্ডার ট্র্যাক করুন', Colors.green, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderTrackingScreen()));
                  }),
                  _buildCard(context, '📏 Size Calculator', 'সাইজ ক্যালকুলেটর', Colors.teal, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SizeCalculatorScreen()));
                  }),
                  _buildCard(context, '🎁 Your Offers', 'অফার দেখুন', Colors.pink, _launchWebsite),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text('SeiRokom Fashion - Made with 🫶🇧🇩❤️🤲',
                    style: TextStyle(color: Colors.white.withOpacity(0.5))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String subtitle, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
