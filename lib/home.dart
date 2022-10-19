import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature/signature.dart';
import 'package:test_esign/model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SignatureController _controller;
  int _index = 0;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.red,
      exportBackgroundColor: Colors.blue,
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

  _showImage() {
    showDialog(
      context: context,
      builder: (context) {
        return _index == 1
            ? AlertDialog(
                content: _controller.isNotEmpty
                    ? SvgPicture.string(_controller.toRawSVG()!)
                    : const Text("No Image"),
              )
            : AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                children: [
                  TextButton(
                    child: const Text("Type"),
                    onPressed: () {
                      if (_index == 1) {
                        setState(() {
                          _index = 0;
                        });
                        if (_controller.isNotEmpty) {
                          _controller.clear();
                        }
                      }
                    },
                  ),
                  TextButton(
                    child: const Text("Draw"),
                    onPressed: () {
                      if (_index == 0) {
                        setState(() {
                          _index = 1;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            _index == 0
                ? SizedBox(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  )
                : Signature(
                    controller: _controller,
                    height: 300,
                    backgroundColor: Colors.lightBlueAccent,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_controller.isNotEmpty) {
                      _controller.clear();
                    }
                    if (textEditingController.text.isNotEmpty) {
                      textEditingController.clear();
                    }
                  },
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.isNotEmpty ||
                        textEditingController.text.isNotEmpty) {
                      _showImage();
                    }
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
}
