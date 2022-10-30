import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

TutorialCoachMark initCoachMark(
  BuildContext context,
  List<TargetFocus> targets,
) {
  return TutorialCoachMark(
    targets: targets,
    colorShadow: Colors.red,
    textSkip: "SKIP",
    paddingFocus: 10,
    opacityShadow: 0.8,
    onFinish: () {
      print("finish");
    },
    onClickTarget: (target) {
      print('onClickTarget: $target');
    },
    onClickTargetWithTapPosition: (target, tapDetails) {
      print("target: $target");
      print(
          "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
    },
    onClickOverlay: (target) {
      print('onClickOverlay: $target');
    },
    onSkip: () {
      print("skip");
    },
  );
}
