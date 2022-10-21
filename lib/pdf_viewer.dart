import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:test_esign/sf_helper.dart';

class PDFViewerPage extends StatefulWidget {
  const PDFViewerPage({
    super.key,
    required this.signImage,
  });
  final Uint8List signImage;

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  File? pdfFile;
  Offset _offset = const Offset(100, 100);
  int pdfPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PDF Viewer",
        ),
      ),
      body: pdfFile == null
          ? Center(
              child: InkResponse(
                child: const Icon(
                  Icons.upload_file,
                  size: 50,
                ),
                onTap: () {
                  _pickFile();
                },
              ),
            )
          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(
                      color: Colors.blue,
                    ),
                  ),
                  child: SfPdfViewer.file(
                    pdfFile!,
                    onPageChanged: (page) {
                      pdfPageIndex = page.newPageNumber - 1;
                      setState(() {});
                    },
                    enableDoubleTapZooming: false,
                    onDocumentLoaded: (details) {
                      debugPrint(details.toString());
                    },
                    onZoomLevelChanged: (details) {
                      debugPrint(details.toString());
                    },
                    pageLayoutMode: PdfPageLayoutMode.single,
                  ),
                ),
                Positioned(
                  top: _offset.dy - 100,
                  left: _offset.dx,
                  child: Draggable(
                    onDragEnd: (details) {
                      _offset = details.offset;
                      setState(() {});
                    },
                    childWhenDragging: Container(),
                    feedback: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      width: 100,
                      height: 100,
                      child: Image.memory(
                        widget.signImage,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      width: 100,
                      height: 100,
                      child: Image.memory(
                        widget.signImage,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: pdfFile != null
          ? FloatingActionButton(
              onPressed: () {
                _modifyPDF();
              },
              child: const Icon(
                Icons.save,
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      pdfFile = File(result.files.single.path!);
      setState(() {});
    }
  }

  _modifyPDF() async {
    final PdfDocument document = PdfDocument(
      inputBytes: pdfFile!.readAsBytesSync(),
    );
    final PdfPage page = document.pages[pdfPageIndex];
    page.graphics.drawImage(
      PdfBitmap(widget.signImage),
      Rect.fromLTWH(
        _offset.dx,
        _offset.dy - 250,
        150,
        150,
      ),
    );
    await pdfFile!.writeAsBytes(await document.save());
    document.dispose();
    Uint8List uint8list = pdfFile!.readAsBytesSync();
    await SFHelper.setString(
      SFHelper.pdfFile,
      StringHelper.convertUint8ListToString(uint8list),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("Save Success"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "Close",
              ),
            ),
          ],
        );
      },
    );
  }
}

class PDFViewerWidget extends StatelessWidget {
  const PDFViewerWidget({
    super.key,
    required this.pdfFile,
  });
  final Uint8List pdfFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View File",
        ),
      ),
      // body: SfPdfViewer.network(
      //   "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
      // ),
      body: SfPdfViewer.memory(
        pdfFile,
      ),
    );
  }
}
