import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_esign/coachmarks/coachmark_helper.dart';
import 'package:test_esign/coachmarks/targets_data.dart';
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
  late TutorialCoachMark tutorialCoachMark;

  _addTargets() async {
    targetsList = CoachMarkData.myTargets();
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
        actions: [
          IconButton(
            key: targetsList.first.keyTarget,
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Hello $name",
          key: targetsList[1].keyTarget,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: targetsList.last.keyTarget,
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
