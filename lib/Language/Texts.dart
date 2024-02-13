import 'dart:ui';
import 'package:flutter/material.dart';

import 'EnglishTexts.dart';
import 'PolishTexts.dart';

abstract class LanguageTexts{
  late List<String> menu = ["","","",""];
  late List<String> homeDays = ["","","","","","",""];
  late String settingsDarkMode;
  late String settingsLang;
  late List<String> langList = ["",""];
  late String settingsOffset;
  late List<String> timeOffsetList = ["","","",""];
  late String settingsReminder;
  late List<String> reminderList = ["",""];
  late String settingsReminderNote;
  late String settingsDayOffset;
  late String settingsDayOffsetNote;
  late String todosMain;
  late String todosPickerDaily;
  late String todosPickerHabits;
  late String todosPlannedText;
  late String todosPopupEdit;
  late String todosPopupRemove;
  late String todosPopupPostpone;
  late String habitsPopupEdit;
  late String habitsPopupRemove;
  late String habitsPopupMinus;
  late String habitsAlertTitle;
  late String habitsAlertContent;
  late String habitsAlertContentH;
  late String habitsAlertCancel;
  late String habitsAlertConfirm;
  late String todosHabits;
  late List<String> todosFilterList = ["","","",""];
  late String addDailyAppBar;
  late String modifyDailyAppBar;
  late String addDailyName;
  late String addDailyImportance;
  late List<String> addDailyImpList = ["","",""];
  late String addDailyIcon;
  late String addDailyTheme;
  late String addDailyHour;
  late String addDailyHourPickOther;
  late String addSave;
  late String addDailyAppearDay;
  late String addDailyAppearToday;
  late String addDailyAppearTomorrow;
  late String addHabitAppBar;
  late String addHabitName;
  late String addHabitDateOfAppearance;
  late String addHabitToday;
  late String addHabitTomorrow;
  late String addHabitFrequency;
  late String addHabitFrequencyWeek;
  late String addHabitLength;
  late String addHabitDays;
  late String addHabitUndefined;
  late String addHabitIcon;
  late String addHabitPickDate;
  late String addHabitTheme;
  late String addHabitWarning;
  late String modifyHabitAppBar;
  late List<String> habitsFilterList = ["",""];
  late String habitsFrequency;
  late String habitsConn;
  late String habitsProgress;
  late String habitsProgressDays;
  late String habitsStartDay;
  late String showFutureText;
  late String addThingWrongName;
  late String dayString;
  late String daysString;
  late String achievementsTitle;
  late List<String> achievementsTitleText = ["","","","",""];
  late List<String> achievementsMainText = ["","","","",""];
  late String finishedHabitsName;
  late String detailsHabitName;
  late String homeLevel;
  late String homeSelectButton;
  late String pickPetText;
  late List<String> attributes1 = ["","","","","",""];
  late List<String> attributes2 = ["","","","","",""];
  late List<String> attributes3 = ["","","","","",""];
  late String savingBackupShort;
  late String savingBackupLong;
  late String readingBackupShort;
  late String readingBackupLong;
  late String backupButton1;
  late String backupButton2;
  late String warningBackup;
  late String warningTitle;
}

class Texts{
  LanguageTexts texts;

  Texts({required String language})
      : texts = language == "ENG" ? EnglishTexts() : PolishTexts();
}