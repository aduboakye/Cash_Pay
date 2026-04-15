import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ApplyPage extends StatefulWidget {
  const ApplyPage({super.key});

  @override
  State<ApplyPage> createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  File? ghanaCardImage;
  File? selfieImage;

  final ImagePicker _picker = ImagePicker();

  /// Pick Image Function
  Future<void> _pickImage(ImageSource source, bool isCard) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        if (isCard) {
          ghanaCardImage = File(picked.path);
        } else {
          selfieImage = File(picked.path);
        }
      });
    }
  }

  /// Bottom Sheet
  void _showPicker(bool isCard) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, isCard);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, isCard);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Image Box Widget
  Widget _imageBox(File? image, String text, bool isCard) {
    return GestureDetector(
      onTap: () => _showPicker(isCard),
      child: Container(
        height: 160,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: image == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    Text(text, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(image, fit: BoxFit.cover),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3A3A3A), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        // Fixed: Added white IconButton with pop navigation
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Apply for a Loan",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF3A3A3A), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Full Name + Address
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildTextField("Full Name", "Sarah Mensah"),
                    const SizedBox(height: 10),
                    _buildTextField("Address", "123 Main Street, Accra"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Ghana Card Upload
              _buildLabel("Upload Ghana Card"),
              _imageBox(ghanaCardImage, "Tap to upload Ghana Card", true),

              /// Selfie Verification
              _buildLabel("Take Selfie for Verification"),
              _imageBox(selfieImage, "Tap to take selfie", false),

              const SizedBox(height: 10),

              _buildLabel("Ghana Card Number"),
              _buildInput("7891234567"),

              _buildLabel("Amount Needed"),
              _buildInput("\$5,000"),

              _buildLabel("Loan Purpose"),
              _buildInput("Medical Expenses"),

              _buildLabel("Functioning MoMo Number"),
              _buildInput("+233 24 123 4567"),

              _buildLabel("Next of Kin Details"),
              _buildInput("Michael Mensah"),

              const SizedBox(height: 20),

              /// Submit Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Text(
                    "Submit Application",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "By applying, you agree to our Terms and Conditions",
                style: TextStyle(color: Colors.black, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Label
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  /// Input Field
  Widget _buildInput(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ), // Black border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2.0,
            ), // Black border when not focused
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.5,
            ), // Slightly thicker black when focused
          ),
        ),
      ),
    );
  }

  /// Top Fields
  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
