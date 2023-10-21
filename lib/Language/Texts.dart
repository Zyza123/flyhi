import 'dart:ui';
import 'package:flutter/material.dart';

class Texts{
  String languageS = "ENG";
  late List<String> menu = ["","","",""];
  late String settingsDarkMode;
  late String settingsLang;
  late List<String> langList = ["",""];

  void setTextLang(String language){
    menu[0] = language == "ENG" ? "Home" : "Dom";
    menu[1] = language == "ENG" ? "Habits" : "Nawyki";
    menu[2] = language == "ENG" ? "Rewards" : "Nagrody";
    menu[3] = language == "ENG" ? "Settings" : "Ustawienia";
    settingsDarkMode = language == "ENG" ? "Dark mode" : "Tryb nocny";
    settingsLang = language == "ENG" ? "Language" : "Język";
    langList[0] = language == "ENG" ? "english" : "angielski";
    langList[1] = language == "ENG" ? "polish" : "polski";
  }
}