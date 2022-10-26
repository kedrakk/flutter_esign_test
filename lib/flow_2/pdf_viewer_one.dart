import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:test_esign/common/uri_helper.dart';
import 'package:test_esign/flow_2/add_sign_one.dart';

import '../flow_1/sf_helper.dart';

class PDFViewerOnePage extends StatefulWidget {
  const PDFViewerOnePage({super.key});

  @override
  State<PDFViewerOnePage> createState() => _PDFViewerOnePageState();
}

class _PDFViewerOnePageState extends State<PDFViewerOnePage> {
  File? pdfFile;
  int signIndex = 0;
  Uint8List? signImage;
  Rect signPosition = Rect.zero;
  final PdfViewerController pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PDF Viewer",
        ),
        actions: [
          IconButton(
            onPressed: () {
              _pickFile();
            },
            icon: const Icon(
              Icons.upload_file,
            ),
          ),
          if (pdfFile != null)
            IconButton(
              onPressed: () {
                _addsign();
              },
              icon: const Icon(
                Icons.sign_language,
              ),
            ),
        ],
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
                SfPdfViewer.file(
                  pdfFile!,
                  controller: pdfViewerController,
                  onDocumentLoaded: (details) {},
                  onHyperlinkClicked: (details) {
                    String linkString = details.uri.toString().stripString();
                    if (linkString.toLowerCase() == "e_sign") {
                      _addsign();
                    }
                  },
                  enableTextSelection: true,
                  enableDoubleTapZooming: true,
                  canShowHyperlinkDialog: false,
                ),
                Positioned.fromRect(
                  rect: signPosition,
                  child: signImage != null
                      ? Image.memory(
                          signImage!,
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                )
              ],
            ),
    );
  }

  _modifyPDF() async {
    final PdfDocument document = PdfDocument(
      inputBytes: pdfFile!.readAsBytesSync(),
    );
    final PdfPage page = document.pages[signIndex];
    Rect newRect = Rect.fromLTWH(
      signPosition.left,
      signPosition.top -
          ((100 - signPosition.height) / 2 + signPosition.height),
      100,
      100,
    );
    page.graphics.drawImage(
      PdfBitmap(signImage!),
      newRect,
    );
    await pdfFile!.writeAsBytes(await document.save());
    document.dispose();
    Uint8List uint8list = pdfFile!.readAsBytesSync();
    await SFHelper.setString(
      SFHelper.pdfFile,
      StringHelper.convertUint8ListToString(uint8list),
    );
    setState(() {});
  }

  _addsign() async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddSignOneWidget(),
      ),
    );
    if (res != null && res is Uint8List) {
      signImage = res;
      _modifyPDF();
    }
  }

  _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      pdfFile = File(result.files.single.path!);
      _getPosition();
      setState(() {});
    }
  }

  _getPosition() {
    final PdfDocument document = PdfDocument(
      inputBytes: pdfFile!.readAsBytesSync(),
    );
    try {
      List<MatchedItem> textCollection =
          PdfTextExtractor(document).findText(['e_sign']);
      if (textCollection.isNotEmpty) {
        MatchedItem matchedText = textCollection[0];
        signPosition = matchedText.bounds;
        signIndex = matchedText.pageIndex;
      }
    } catch (err) {
      debugPrint(err.toString());
    }
    document.dispose();
  }
}
