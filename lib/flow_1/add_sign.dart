import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:test_esign/common/model.dart';
import 'dart:ui' as ui;

import 'package:test_esign/flow_1/sf_helper.dart';

class AddSign extends StatefulWidget {
  const AddSign({
    super.key,
  });

  @override
  State<AddSign> createState() => _AddSignState();
}

class _AddSignState extends State<AddSign> with TickerProviderStateMixin {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  late TabController tabController;
  // final ImagePicker _picker = ImagePicker();
  File? fileImage;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add or Edit Sign"),
        bottom: TabBar(
          labelPadding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          controller: tabController,
          tabs: Tabs.allTabs.map((e) => Text(e.tabName)).toList(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              height: 300,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  SfSignaturePad(
                    key: _signaturePadKey,
                    minimumStrokeWidth: 1,
                    maximumStrokeWidth: 3,
                    strokeColor: Colors.black,
                    backgroundColor: Colors.transparent,
                  ),
                  GestureDetector(
                    onTap: () => _uploadImage(),
                    child: fileImage != null
                        ? Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                  fileImage!,
                                ),
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.upload_file,
                          ),
                  )
                ],
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
                    if (fileImage != null) {
                      fileImage = null;
                    }
                    setState(() {});
                  },
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _getImage();
                  },
                  child: const Text("Select"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _cropImage(File(result.files.single.path!));
    }
  }

  // _uploadImage1() async {
  //   final XFile? image = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   if (image != null) {
  //     _cropImage(File(image.path));
  //   }
  // }

  _cropImage(File file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        fileImage = File(croppedFile.path);
      });
    }
  }

  _getImage() {
    if (tabController.index == 0) {
      _showPadImage();
    } else {
      _showUploadImage();
    }
  }

  _showUploadImage() {
    if (fileImage != null) {
      Uint8List bytes = fileImage!.readAsBytesSync();
      _showMemoryImage(bytes);
    }
  }

  _showPadImage() async {
    if (_signaturePadKey.currentState != null) {
      ui.Image image = await _signaturePadKey.currentState!.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List uint8list = Uint8List.view(byteData.buffer);
        _showMemoryImage(uint8list);
      }
    }
  }

  _showMemoryImage(Uint8List uint8list) async {
    await SFHelper.setString(
      SFHelper.signImage,
      StringHelper.convertUint8ListToString(
        uint8list,
      ),
    );
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: AlertDialog(
            content: Image.memory(
              uint8list,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back",
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
