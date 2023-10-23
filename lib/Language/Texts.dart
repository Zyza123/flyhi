import 'dart:ui';
import 'package:flutter/material.dart';

class Texts{
  String languageS = "ENG";
  late List<String> menu = ["","","",""];
  late String settingsDarkMode;
  late String settingsLang;
  late List<String> langList = ["",""];
  late String todosMain;
  late String todosPickerDaily;
  late String todosPickerHabits;
  late String todosPlannedText;
  late String todosHabits;

  void setTextLang(String language){
    menu[0] = language == "ENG" ? "Home" : "Dom";
    menu[1] = language == "ENG" ? "Habits" : "Nawyki";
    menu[2] = language == "ENG" ? "Rewards" : "Nagrody";
    menu[3] = language == "ENG" ? "Settings" : "Ustawienia";
    settingsDarkMode = language == "ENG" ? "Dark mode" : "Tryb nocny";
    settingsLang = language == "ENG" ? "Language" : "Język";
    langList[0] = language == "ENG" ? "english" : "angielski";
    langList[1] = language == "ENG" ? "polish" : "polski";
    todosMain = language == "ENG" ? "TODOS" : "AKTYWNOŚĆ";
    todosPickerDaily = language == "ENG" ? "Daily" : "Dzienne";
    todosPickerHabits = language == "ENG" ? "Habits" : "Nawyki";
    todosPlannedText = language == "ENG" ? "Planned for today" : "Zaplanowane na dzisiaj";
    todosHabits = language == "ENG" ? "My habits" : "Moje nawyki";

  }
}