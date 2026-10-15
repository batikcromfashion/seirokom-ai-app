import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminAddProductScreen extends StatefulWidget {
  const AdminAddProductScreen({Key? key}) : super(key: key);
  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _uploadProduct() async {
    if (_titleController.text.isEmpty || _priceController.text.isEmpty || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('অনুগ্রহ করে নাম, দাম এবং ছবি যোগ করুন!')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('product_images/$fileName.jpg');
      await ref.putFile(_imageFile!);
      String imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('products').add({
        'title': _titleController.text.trim(),
        'price': '৳ ${_priceController.text.trim()}',
        'description': _descController.text.trim(),
        'image': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      setState(() {
        _isLoading = false;
        _titleController.clear();
        _priceController.clear();
        _descController.clear();
        _imageFile = null;
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('প্রোডাক্ট সফলভাবে যোগ করা হয়েছে!')));
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // FIX: ডার্ক
      appBar: AppBar(title: const Text('নতুন প্রোডাক্ট যোগ (Admin)'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180, width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber, width: 2)),
                child: _imageFile != null ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(_imageFile!, fit: BoxFit.cover)) 
                : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo, size: 40, color: Colors.grey), Text('প্রোডাক্টের ছবি নির্বাচন করুন', style: TextStyle(color: Colors.grey))]),
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: _titleController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'প্রোডাক্টের নাম', labelStyle: TextStyle(color: Colors.white70), border: OutlineInputBorder(), filled: true, fillColor: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            TextField(controller: _priceController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'দাম (টাকা)', labelStyle: TextStyle(color: Colors.white70), border: OutlineInputBorder(), filled: true, fillColor: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            TextField(controller: _descController, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'বিস্তারিত বিবরণ (ঐচ্ছিক)', labelStyle: TextStyle(color: Colors.white70), border: OutlineInputBorder(), filled: true, fillColor: Color(0xFF1E293B))),
            const SizedBox(height: 20),
            _isLoading ? const Center(child: CircularProgressIndicator()) 
            : SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _uploadProduct, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), child: const Text('প্রোডাক্ট যোগ করুন', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }
}
