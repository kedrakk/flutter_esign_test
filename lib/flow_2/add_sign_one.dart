import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

class AddSignOneWidget extends StatefulWidget {
  const AddSignOneWidget({super.key});

  @override
  State<AddSignOneWidget> createState() => _AddSignOneWidgetState();
}

class _AddSignOneWidgetState extends State<AddSignOneWidget> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  Uint8List? uint8list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Draw Your Sign",
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            height: 300,
            child: SfSignaturePad(
              key: _signaturePadKey,
              minimumStrokeWidth: 3,
              maximumStrokeWidth: 5,
              strokeColor: Colors.red,
              backgroundColor: Colors.transparent,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_signaturePadKey.currentState != null) {
                    _signaturePadKey.currentState!.clear();
                  }
                  setState(() {});
                },
                child: const Text("Clear"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_signaturePadKey.currentState != null) {
                    await _selectImage();
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(uint8list);
                },
                child: const Text("Select"),
              ),
            ],
          )
        ],
      ),
    );
  }

  _selectImage() async {
    ui.Image image = await _signaturePadKey.currentState!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      uint8list = Uint8List.view(byteData.buffer);
    }
  }
}
