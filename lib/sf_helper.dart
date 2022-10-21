import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SFHelper {
  static String signImage = "signImage";
  static String pdfFile = "pdfFile";

  static Future<void> setString(String key, String value) async {
    await SharedPreferences.getInstance().then(
      (val) => val.setString(
        key,
        value,
      ),
    );
  }

  static Future<String> getString(String key) async {
    String? res = await SharedPreferences.getInstance().then(
      (val) => val.getString(
        key,
      ),
    );
    return res ?? "";
  }
}

class StringHelper {
  static Uint8List convertStringToUint8List(String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    return unit8List;
  }

  static String convertUint8ListToString(Uint8List uint8list) {
    return String.fromCharCodes(uint8list);
  }

  static Uint8List convertIntListToUint8List(List<int> intList) {
    return Uint8List.fromList(intList);
  }
}
