import 'package:flutter/material.dart';
import 'package:test_esign/theme.dart';

class TextAndStyle {
  String textName;
  TextStyle fontStyle;
  bool isSelected;
  TextAndStyle({
    required this.textName,
    required this.fontStyle,
    required this.isSelected,
  });

  static List<TextAndStyle> allStyles = [
    TextAndStyle(
      textName: "allura",
      fontStyle: AppTextStyles.allura,
      isSelected: true,
    ),
    TextAndStyle(
      textName: "alexBrush",
      fontStyle: AppTextStyles.alexBrush,
      isSelected: false,
    ),
    TextAndStyle(
      textName: "sacremento",
      fontStyle: AppTextStyles.sacremento,
      isSelected: false,
    ),
    TextAndStyle(
      textName: "parisienne",
      fontStyle: AppTextStyles.parisienne,
      isSelected: false,
    ),
  ];
}
