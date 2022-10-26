import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_esign/flow_1/add_sign.dart';
import 'package:test_esign/flow_1/pdf_viewer.dart';
import 'package:test_esign/flow_1/sf_helper.dart';

class StartPage extends StatefulWidget {
  const StartPage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Uint8List? image;
  Uint8List? pdfFile;

  @override
  void initState() {
    _getSignInfo();
    super.initState();
  }

  _getSignInfo() async {
    String sign = await SFHelper.getString(
      SFHelper.signImage,
    );
    if (sign.isNotEmpty) {
      image = StringHelper.convertStringToUint8List(sign);
    }
    String pdf = await SFHelper.getString(
      SFHelper.pdfFile,
    );
    if (pdf.isNotEmpty) {
      pdfFile = StringHelper.convertStringToUint8List(pdf);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
          if (image != null)
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerPage(
                      signImage: image!,
                    ),
                  ),
                );
                _getSignInfo();
              },
              icon: const Icon(
                Icons.file_copy,
              ),
            ),
        ],
      ),
      body: Center(
        child: image != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Your Sign"),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.memory(image!),
                  const SizedBox(
                    height: 30,
                  ),
                  if (pdfFile != null) const Text("Your File"),
                  if (pdfFile != null)
                    const SizedBox(
                      height: 20,
                    ),
                  if (pdfFile != null)
                    ListTile(
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
                    ),
                ],
              )
            : const Text(
                "There is no sign",
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSign(),
            ),
          );
          _getSignInfo();
        },
      ),
    );
  }
}
