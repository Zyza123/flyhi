import 'package:flutter/material.dart';
import 'LanguagePreference.dart';

class LanguageProvider with ChangeNotifier {
  LanguagePreference languagePreference = LanguagePreference();
  String _language = "ENG";

  String get language => _language;

  set language(String value) {
    _language = value;
    languagePreference.setLanguage(value);
    notifyListeners();
  }
}