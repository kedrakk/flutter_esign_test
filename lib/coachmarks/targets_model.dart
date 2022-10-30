import 'package:flutter/material.dart';

class TargetModel {
  String identity;
  String title;
  String subtitle;
  GlobalKey keyIndex;
  TargetModel({
    required this.identity,
    required this.title,
    required this.subtitle,
    required this.keyIndex,
  });

  static List<TargetModel> targetModelList = [
    TargetModel(
      identity: "Target 1",
      title: "Drawer Open",
      subtitle: "Click that place to open drawer",
      keyIndex: GlobalKey(),
    ),
    TargetModel(
      identity: "Target 2",
      title: "Main content",
      subtitle: "The new main content will be displayed here",
      keyIndex: GlobalKey(),
    ),
    TargetModel(
      identity: "Target 3",
      title: "Changing content",
      subtitle:
          "The main function controlling main content can be performed by clicking here",
      keyIndex: GlobalKey(),
    ),
  ];
}
