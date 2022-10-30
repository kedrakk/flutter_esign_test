import 'package:flutter/material.dart';
import 'package:test_esign/coachmarks/targets_model.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CoachMarkData {
  // static GlobalKey key1 = GlobalKey();
  // static GlobalKey key2 = GlobalKey();
  // static GlobalKey key3 = GlobalKey();

  // GlobalKey getCurrentKey(int index){
  //   return GlobalKey()
  // }

  static List<TargetFocus> myTargets() {
    List<TargetFocus> res = [];
    for (var myTarget in TargetModel.targetModelList) {
      res.add(
        TargetFocus(
          enableOverlayTab: true,
          identify: myTarget.identity,
          alignSkip: Alignment.bottomLeft,
          keyTarget: myTarget.keyIndex,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (myTarget.title.isNotEmpty)
                    Text(
                      myTarget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  if (myTarget.subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        myTarget.subtitle,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      );
    }
    return res;
  }
}
