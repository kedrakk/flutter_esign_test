import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_esign/coachmarks_1/showcase_repo.dart';

class CoachMarkOnePage extends StatefulWidget {
  const CoachMarkOnePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<CoachMarkOnePage> createState() => _CoachMarkOnePageState();
}

class _CoachMarkOnePageState extends State<CoachMarkOnePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: ShowCaseWidget(
        onStart: (index, key) {
          debugPrint('onStart: $index, $key');
        },
        onComplete: (index, key) {
          debugPrint('onComplete: $index, $key');
          if (index == 4) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle.light.copyWith(
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white,
              ),
            );
          }
        },
        blurValue: 1,
        builder: Builder(
          builder: (context) => const MyActorWidget(),
        ),
        autoPlayDelay: const Duration(seconds: 3),
      ),
    );
  }
}

class MyActorWidget extends StatefulWidget {
  const MyActorWidget({
    super.key,
  });

  @override
  State<MyActorWidget> createState() => _MyActorWidgetState();
}

class _MyActorWidgetState extends State<MyActorWidget> {
  final random = Random();
  String name = "Dylan";
  List<String> myactors = ["Dylan", "Cole", "Martin", "Christ", "William"];
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final ShowCaseRepo _showCaseRepo = ShowCaseRepo();

  @override
  void initState() {
    bool isOneShow = _showCaseRepo.isCurrentShowCaseShow(1);
    bool isTwoShow = _showCaseRepo.isCurrentShowCaseShow(2);
    List<GlobalKey<State<StatefulWidget>>> showIds = [];
    if (isOneShow) {
      showIds.add(_one);
    }
    if (isTwoShow) {
      showIds.add(_two);
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase(showIds),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Showcase(
          key: _two,
          description: 'Check here for result',
          child: Text(
            "Hello $name",
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Showcase(
          key: _one,
          description: 'Tap here to shuffle',
          child: const Icon(
            Icons.add,
          ),
        ),
        onPressed: () {
          var index = random.nextInt(4);
          name = myactors[index];
          setState(() {});
        },
      ),
    );
  }
}
