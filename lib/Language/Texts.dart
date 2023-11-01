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
  late String todosPopupEdit;
  late String todosPopupRemove;
  late String todosPopupPostpone;
  late String todosHabits;
  late List<String> todosFilterList = ["","",""];
  late String addDailyAppBar;
  late String modifyDailyAppBar;
  late String addDailyName;
  late String addDailyImportance;
  late List<String> addDailyImpList = ["","",""];
  late String addDailyIcon;
  late String addDailyTheme;
  late String addDailySave;
  late String addDailyAppearDay;
  late String addDailyAppearToday;
  late String addDailyAppearTomorrow;

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
    todosPopupEdit = language == "ENG" ? "Edit " : "Edytuj ";
    todosPopupRemove = language == "ENG" ? "Remove " : "Usuń ";
    todosPopupPostpone = language == "ENG" ? "Postpone " : "Przełóż ";
    todosHabits = language == "ENG" ? "My habits" : "Moje nawyki";
    todosFilterList[0] = language == "ENG" ? "In the order added" : "W kolejności dodania";
    todosFilterList[1] = language == "ENG" ? "Importance descending" : "Waga malejąco";
    todosFilterList[2] = language == "ENG" ? "Importance ascending" : "Waga rosnąco";
    addDailyAppBar = language == "ENG" ? "Add Daily" : "Dodaj obowiązek";
    modifyDailyAppBar = language == "ENG" ? "Modify Daily" : "Modyfikuj obowiązek";
    addDailyName = language == "ENG" ? "Name" : "Nazwa";
    addDailyImportance = language == "ENG" ? "Importance" : "Waga";
    addDailyImpList[0] = language == "ENG" ? "high" : "wysoka";
    addDailyImpList[1] = language == "ENG" ? "medium" : "średnia";
    addDailyImpList[2] = language == "ENG" ? "low" : "niska";
    addDailyIcon = language == "ENG" ? "Icon" : "Ikona";
    addDailyTheme = language == "ENG" ? "Theme" : "Motyw";
    addDailySave = language == "ENG" ? "Save   " : "Zapisz   ";
    addDailyAppearDay = language == "ENG" ? "Appearance day" : "Data pojawienia";
    addDailyAppearToday = language == "ENG" ? "Today" : "Dzisiaj";
    addDailyAppearTomorrow = language == "ENG" ? "Tomorrow" : "Jutro";

  }
}