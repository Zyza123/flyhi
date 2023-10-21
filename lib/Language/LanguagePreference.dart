import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class LanguagePreference {
  static const LANGUAGE_STATUS = "LANGUAGESTATUS";

  setLanguage(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LANGUAGE_STATUS, value);
    print('zmiana: $LANGUAGE_STATUS : $value');
  }

  Future<String> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LANGUAGE_STATUS) ?? "ENG";
  }
}