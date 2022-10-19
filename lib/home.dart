import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:test_esign/model.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final TextEditingController textEditingController = TextEditingController();
  late SignatureController _controller;
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  late TabController tabController;
  final ImagePicker _picker = ImagePicker();
  File? fileImage;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    _controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    _controller.addListener(() {
      debugPrint(_controller.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: TextFormField(
                        controller: textEditingController,
                        style: TextAndStyle.allStyles
                            .firstWhere(
                              (element) => element.isSelected,
                            )
                            .fontStyle,
                        decoration: InputDecoration(
                          suffixIcon: PopupMenuButton(
                            icon: const Icon(Icons.font_download),
                            itemBuilder: (BuildContext context) {
                              return TextAndStyle.allStyles
                                  .map(
                                    (e) => PopupMenuItem(
                                      child: Text(
                                        e.textName,
                                        style: e.fontStyle,
                                      ),
                                      onTap: () {
                                        if (!e.isSelected) {
                                          TextAndStyle.allStyles
                                              .firstWhere(
                                                (element) => element.isSelected,
                                              )
                                              .isSelected = false;
                                          e.isSelected = true;
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  )
                                  .toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Signature(
                    controller: _controller,
                    height: double.infinity,
                    backgroundColor: Colors.lightBlueAccent,
                  ),
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
                    if (textEditingController.text.isNotEmpty) {
                      textEditingController.clear();
                    }
                    if (_controller.isNotEmpty) {
                      _controller.clear();
                    }
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
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _cropImage(File(image.path));
    }
  }

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
      _showUploadImage();
    }
  }

  _getImage() {
    if (tabController.index == 0) {
      _showTextImage();
    } else if (tabController.index == 1) {
      _showSvgImage();
    } else if (tabController.index == 2) {
      _showPadImage();
    } else {
      _showUploadImage();
    }
  }

  _showUploadImage() {
    if (fileImage != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 300,
              child: Image.file(
                fileImage!,
              ),
            ),
          );
        },
      );
    }
  }

  _showTextImage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            child: Center(
              child: Text(
                textEditingController.text,
                style: TextAndStyle.allStyles
                    .firstWhere(
                      (element) => element.isSelected,
                    )
                    .fontStyle,
              ),
            ),
          ),
        );
      },
    );
  }

  _showSvgImage() {
    if (_controller.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 300,
              child: SvgPicture.string(_controller.toRawSVG()!),
            ),
          );
        },
      );
    }
  }

  _showPadImage() async {
    if (_signaturePadKey.currentState != null) {
      ui.Image image = await _signaturePadKey.currentState!.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List uint8list = Uint8List.view(byteData.buffer);
        showDialog(
          context: context,
          builder: (context) {
            return SizedBox(
              height: 300,
              child: AlertDialog(
                content: Image.memory(
                  uint8list,
                ),
              ),
            );
          },
        );
      }
    }
  }
}
