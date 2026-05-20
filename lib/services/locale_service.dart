import 'package:flutter/material.dart';

class LocaleService extends ChangeNotifier {
  bool isArabic = false;

  void setArabic(bool value) {
    isArabic = value;
    notifyListeners();
  }

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  String t(String fr, String ar) => isArabic ? ar : fr;
}
