import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PDFViewerFlow3 extends StatefulWidget {
  const PDFViewerFlow3({super.key});

  @override
  State<PDFViewerFlow3> createState() => _PDFViewerFlow3State();
}

class _PDFViewerFlow3State extends State<PDFViewerFlow3> {
  File? pdfFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Document",
        ),
      ),
      body: pdfFile != null
          ? Container()
          : IconButton(
              onPressed: () => _pickFile(),
              icon: const Icon(
                Icons.file_upload,
              ),
            ),
    );
  }

  _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      pdfFile = File(result.files.single.path!);
      setState(() {});
    }
  }
}
