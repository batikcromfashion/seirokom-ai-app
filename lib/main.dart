import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_screen.dart';
import 'tryon_screen.dart';
import 'chatbot_screen.dart';
import 'post_screen.dart'; // নতুন AI Post
import 'admin_add_product_screen.dart'; // নতুন Admin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase Error, but App will run: $e");
  }
  runApp(const SeiRokomApp());
}

class SeiRokomApp extends StatelessWidget {
  const SeiRokomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SeiRokom Fashion',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // ডার্ক, একদম ঠিক
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    TryOnScreen(),
    ChatbotScreen(),
    PostScreen(), // ৪ নম্বরে তোমার Sohidul পেইজের Assistant
    AdminAddProductScreen(), // ৫ নম্বরে Admin
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E293B),
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // ৫টা Tab এর জন্য জরুরি
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'হোম'),
          BottomNavigationBarItem(icon: Icon(Icons.checkroom), label: 'ট্রাই-অন'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'AI চ্যাট'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'AI পোস্ট'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
        ],
      ),
    );
  }
}
