import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  File? _selectedImage;
  File? _selectedVideo;
  File? _selectedFile;

  final ImagePicker _picker = ImagePicker();

  // 📸 Camera Image
  Future<void> _pickImageCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _selectedVideo = null;
        _selectedFile = null;
      });
    }
  }

  // 🖼 Gallery Image
  Future<void> _pickImageGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _selectedVideo = null;
        _selectedFile = null;
      });
    }
  }

  // 🎥 Pick Video
  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        _selectedVideo = File(video.path);
        _selectedImage = null;
        _selectedFile = null;
      });
    }
  }

  // 📁 Pick Any File
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _selectedImage = null;
        _selectedVideo = null;
      });
    }
  }

  // 🔥 Bottom Sheet (Attach Options)
  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 200,
          child: Column(
            children: [
              const Text(
                "Choose Option",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOption(Icons.camera_alt, "Camera", _pickImageCamera),
                  _buildOption(Icons.image, "Gallery", _pickImageGallery),
                  _buildOption(Icons.videocam, "Video", _pickVideo),
                  _buildOption(Icons.insert_drive_file, "File", _pickFile),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(IconData icon, String text, VoidCallback onTap) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.black,
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              onTap();
            },
          ),
        ),
        const SizedBox(height: 5),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              "Cash Pay",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call, color: Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.mail, color: Colors.black),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF3A3A3A),
      ),

      body: Column(
        children: [
          // 🔥 Preview Section
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.file(_selectedImage!, height: 150),
            ),

          if (_selectedVideo != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Video Selected: ${_selectedVideo!.path.split('/').last}",
                style: const TextStyle(fontSize: 16),
              ),
            ),

          if (_selectedFile != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "File: ${_selectedFile!.path.split('/').last}",
                style: const TextStyle(fontSize: 16),
              ),
            ),

          const Spacer(),

          // 🔥 Input Area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Message",
                        filled: true,
                        fillColor: Colors.white,

                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 📎 Attach Button
                            IconButton(
                              icon: const Icon(Icons.attach_file),
                              onPressed: _showAttachmentOptions,
                            ),

                            // 📷 Camera Direct
                            IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: _pickImageCamera,
                            ),
                          ],
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.black),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.black,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        print("Send tapped");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
