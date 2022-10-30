import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_esign/coachmarks/coachmark_helper.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MainCoachMarksPage extends StatefulWidget {
  const MainCoachMarksPage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<MainCoachMarksPage> createState() => _MainCoachMarksPageState();
}

class _MainCoachMarksPageState extends State<MainCoachMarksPage> {
  final random = Random();
  String name = "Dylan";
  List<String> myactors = ["Dylan", "Cole", "Martin", "Christ", "William"];
  List<TargetFocus> targetsList = [];
  GlobalKey key = GlobalKey();
  GlobalKey key1 = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;

  _addTargets() async {
    targetsList = [
      TargetFocus(
        enableOverlayTab: true,
        identify: "Target 1",
        keyTarget: key,
        alignSkip: Alignment.topLeft,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Titulo lorem ipsum",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "Target 2",
        keyTarget: key1,
        enableOverlayTab: true,
        alignSkip: Alignment.topLeft,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Multiples content",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ];
    tutorialCoachMark = initCoachMark(context, targetsList);
  }

  _showCoachmark() {
    tutorialCoachMark.show(context: context);
  }

  @override
  void initState() {
    _addTargets();
    Future.delayed(Duration.zero, () {
      _showCoachmark();
    });
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
        child: Text(
          "Hello $name",
          key: key1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: key,
        child: const Icon(Icons.add),
        onPressed: () {
          var index = random.nextInt(4);
          name = myactors[index];
          setState(() {});
        },
      ),
    );
  }
}
