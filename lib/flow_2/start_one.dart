import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_esign/flow_1/pdf_viewer.dart';
import 'package:test_esign/flow_2/pdf_viewer_one.dart';

import '../flow_1/sf_helper.dart';

class StartOnePage extends StatefulWidget {
  const StartOnePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<StartOnePage> createState() => _StartOnePageState();
}

class _StartOnePageState extends State<StartOnePage> {
  Uint8List? pdfFile;

  _getSignInfo() async {
    String pdf = await SFHelper.getString(
      SFHelper.pdfFile,
    );
    if (pdf.isNotEmpty) {
      pdfFile = StringHelper.convertStringToUint8List(pdf);
    }
    setState(() {});
  }

  @override
  void initState() {
    _getSignInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Center(
        child: pdfFile != null
            ? ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text("my file"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerWidget(
                        pdfFile: pdfFile!,
                      ),
                    ),
                  );
                },
              )
            : const Text(
                "Empty File",
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.new_label),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PDFViewerOnePage(),
            ),
          );
          _getSignInfo();
        },
      ),
    );
  }
}
