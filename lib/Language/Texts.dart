import 'dart:ui';
import 'package:flutter/material.dart';

class Texts{
  String languageS = "ENG";
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

  void setTextLang(String language){
    menu[0] = language == "ENG" ? "Home" : "Dom";
    menu[1] = language == "ENG" ? "Habits" : "Nawyki";
    menu[2] = language == "ENG" ? "Rewards" : "Nagrody";
    menu[3] = language == "ENG" ? "Settings" : "Ustawienia";
    homeDays[0] = language == "ENG" ? "MON": "PON";
    homeDays[1] = language == "ENG" ? "TUE": "WT";
    homeDays[2] = language == "ENG" ? "WED": "ŚR";
    homeDays[3] = language == "ENG" ? "THU": "CZW";
    homeDays[4] = language == "ENG" ? "FRI": "PT";
    homeDays[5] = language == "ENG" ? "SAT": "SOB";
    homeDays[6] = language == "ENG" ? "SUN": "ND";
    settingsDarkMode = language == "ENG" ? "Dark mode" : "Tryb nocny";
    settingsLang = language == "ENG" ? "Language" : "Język";
    langList[0] = language == "ENG" ? "english" : "angielski";
    langList[1] = language == "ENG" ? "polish" : "polski";
    settingsOffset = language == "ENG" ? "Backup day" : "Dzień zapasowy";
    timeOffsetList[0] = language == "ENG" ? "No shift" : "Brak";
    timeOffsetList[1] = language == "ENG" ? "1 hour" : "1 godzina";
    timeOffsetList[2] = language == "ENG" ? "2 hours" : "2 godziny";
    timeOffsetList[3] = language == "ENG" ? "3 hours" : "3 godziny";
    settingsReminder = language == "ENG" ? "Reminder" : "Przypomnienie";
    reminderList[0] = language == "ENG" ? "No reminder" : "Bez przypomnienia";
    reminderList[1] = language == "ENG" ? "minutes: 30" : "minuty: 30";
    settingsReminderNote = language == "ENG" ?
        "Reminder helps you not forget\nabout important events.\nAfter change, it clears all\n"
            "notifications (off) or \napply to duties (on).\nAfter turning on it is required\nto restart the app.\n"
            "Check for notifications permission":
        "Przypomnienie pozwala nie zapomnieć\no ważnych wydarzeniach.\nPo zmianie czyści wszystkie \npowiadomienia"
            "(wyłączone) lub\naktywwuje obowiązki (włączone).\nPo włączeniu wymagany\njest restart aplikacji.\n"
            "Sprawdź pozwolenia powiadomień.";
    settingsDayOffset= language == "ENG" ? "Day shift" : "Przesunięcie doby";
    settingsDayOffsetNote = language == "ENG" ?
    "Day shift might be useful while\ngoing to bed late.\nAfter change, it is required\nto restart the app."
        :  "Przesunięcie doby jest przydatne podczas\n późnego chodzenia spać.\nPo zmianie przesunięcia wymagany\njest restart aplikacji.";
    todosMain = language == "ENG" ? "TODOS" : "AKTYWNOŚĆ";
    todosPickerDaily = language == "ENG" ? "Daily" : "Dzienne";
    todosPickerHabits = language == "ENG" ? "Habits" : "Nawyki";
    todosPlannedText = language == "ENG" ? "Planned daylies" : "Zaplanowane obowiązki";
    todosPopupEdit = language == "ENG" ? "Edit " : "Edytuj ";
    todosPopupRemove = language == "ENG" ? "Remove " : "Usuń ";
    todosPopupPostpone = language == "ENG" ? "Postpone " : "Przełóż ";
    habitsPopupEdit = language == "ENG" ? "Edit " : "Edytuj ";
    habitsPopupRemove = language == "ENG" ? "Remove " : "Usuń ";
    habitsPopupMinus = language == "ENG" ? "Minus " : "Cofnij ";
    habitsAlertTitle = language == "ENG" ? "Remove" : "Usuń";
    habitsAlertContent = language == "ENG" ? "Are u sure u want to remove daily?" : "Na pewno chcesz usunąć obowiązek?";
    habitsAlertContentH = language == "ENG" ? "Are u sure u want to remove habit?" : "Na pewno chcesz usunąć nawyk?";
    habitsAlertCancel = language == "ENG" ? "Cancel" : "Anuluj";
    habitsAlertConfirm = language == "ENG" ? "Confirm" : "Zatwierdź";
    todosHabits = language == "ENG" ? "My habits" : "Moje nawyki";
    todosFilterList[0] = language == "ENG" ? "In the order added" : "W kolejności dodania";
    todosFilterList[1] = language == "ENG" ? "Importance descending" : "Waga malejąco";
    todosFilterList[2] = language == "ENG" ? "Importance ascending" : "Waga rosnąco";
    todosFilterList[3] = language == "ENG" ? "Hourly" : "Godzinowo";
    addDailyAppBar = language == "ENG" ? "Add Daily" : "Dodaj obowiązek";
    modifyDailyAppBar = language == "ENG" ? "Modify Daily" : "Modyfikuj obowiązek";
    addDailyName = language == "ENG" ? "Name" : "Nazwa";
    addDailyImportance = language == "ENG" ? "Importance" : "Waga";
    addDailyImpList[0] = language == "ENG" ? "high" : "wysoka";
    addDailyImpList[1] = language == "ENG" ? "medium" : "średnia";
    addDailyImpList[2] = language == "ENG" ? "low" : "niska";
    addDailyHour = language == "ENG" ? "Hour" : "Godzina";
    addDailyHourPickOther = language == "ENG" ? "Pick other" : "Wybierz inną";
    addDailyIcon = language == "ENG" ? "Icon" : "Ikona";
    addDailyTheme = language == "ENG" ? "Theme" : "Motyw";
    addSave = language == "ENG" ? "Save   " : "Zapisz   ";
    addDailyAppearDay = language == "ENG" ? "Appearance day" : "Data pojawienia";
    addDailyAppearToday = language == "ENG" ? "Today" : "Dzisiaj";
    addDailyAppearTomorrow = language == "ENG" ? "Tomorrow" : "Jutro";
    addHabitAppBar = language == "ENG" ? "Add Habit" : "Dodaj nawyk";
    modifyHabitAppBar = language == "ENG" ? "Modify Habit" : "Modyfikuj nawyk";
    addHabitName = language == "ENG" ? "Name" : "Nazwa";
    addHabitDateOfAppearance = language == "ENG" ? "Start day" : "Data rozpoczęcia";
    addHabitToday = language == "ENG" ? "Today" : "Dzisiaj";
    addHabitTomorrow = language == "ENG" ? "Tomorrow" : "Jutro";
    addHabitFrequency = language == "ENG" ? "Frequency" : "Częstotliwość";
    addHabitFrequencyWeek = language == "ENG" ? "In a week" : "W tygodniu";
    addHabitPickDate = language == "ENG" ? "Pick other" : "Wybierz inną";
    addHabitLength = language == "ENG" ? "Period" : "Okres czasu";
    addHabitDays = language == "ENG" ? "Days" : "Dni";
    addHabitUndefined = language == "ENG" ? "Undefined" : "Nieokreślony";
    addHabitIcon = language == "ENG" ? "Icon" : "Ikona";
    addHabitTheme = language == "ENG" ? "Theme" : "Motyw";
    habitsFilterList[0] = language == "ENG" ? "In the order added" : "W kolejności dodania";
    habitsFilterList[1] = language == "ENG" ? "From the newest" : "Od najnowszych";
    addHabitWarning = language == "ENG" ? "U cannot swap between if days greater than a year !" : "Nie możesz poźniej zmienić jeśli dni przekraczają rok!";
    habitsFrequency = language == "ENG" ? "Frequency" : "Częstotliwość";
    habitsConn = language == "ENG" ? "of" : "na";
    habitsProgress = language == "ENG" ? "Progress" : "Postęp";
    habitsProgressDays = language == "ENG" ? "days" : "dni";
    addThingWrongName = language == "ENG" ? "* This field is required" : "* To pole jest wymagane";
    dayString = language == "ENG" ? "day" : "dzień";
    daysString = language == "ENG" ? "days" : "dni";
    achievementsTitle = language == "ENG" ? "ACHIEVEMENTS" : "OSIĄGNIĘCIA";
    achievementsTitleText[0] = language == "ENG" ? "Persistent" : "Wytrwały";
    achievementsTitleText[1] = language == "ENG" ? "Brave" : "Waleczny";
    achievementsTitleText[2] = language == "ENG" ? "Conscientious" : "Sumienny";
    achievementsTitleText[3] = language == "ENG" ? "Invincible" : "Niepokonany";
    achievementsTitleText[4] = language == "ENG" ? "Protective" : "Opiekuńczy";
    achievementsMainText[0] = language == "ENG" ? "Maintain the habit for a certain number of days." : "Utrzymaj nawyk przez określoną ilość dni.";
    achievementsMainText[1] = language == "ENG" ? "Fulfill certain number of habits (min 50% effectiveness)." : "Wypełnij określoną ilośc nawyków (min 50% efektywności) .";
    achievementsMainText[2] = language == "ENG" ? "Fulfill certain number of duties." : "Wypełnij określoną ilość obowiązków.";
    achievementsMainText[3] = language == "ENG" ? "Achieve the effectiveness of a completed habit (atleast 30 days)." : "Osiągnij skuteczność wykonanego nawyku (minimum 30 dni).";
    achievementsMainText[4] = language == "ENG" ? "Raise your pet's level." : "Podnieś poziom swojego pupila.";
    finishedHabitsName = language == "ENG" ? "Finished Habits": "Ukończone nawyki";
    detailsHabitName = language == "ENG" ? "Habit details": "Szczegóły nawyku";
    homeLevel = language == "ENG" ? "Level": "Poziom";
    homeSelectButton = language == "ENG" ? "SELECT PET": "WYBIERZ PUPILA";
    pickPetText = language == "ENG" ? "Pick your pet": "Wybierz swojego pupila";
    attributes1[0] = language == "ENG" ? "Power" : "Siła";
    attributes2[0] = language == "ENG" ? "Agility" : "Zwinność";
    attributes3[0] = language == "ENG" ? "Independence" : "Samodzielność";
    attributes1[1] = language == "ENG" ? "Wisdom" : "Mądrość";
    attributes2[1] = language == "ENG" ? "Health" : "Zdrowie";
    attributes3[1] = language == "ENG" ? "Courage" : "Odwaga";
    attributes1[2] = language == "ENG" ? "Loyalty" : "Lojalność";
    attributes2[2] = language == "ENG" ? "Cunning" : "Przebiegłość";
    attributes3[2] = language == "ENG" ? "Cooperation" : "Współpraca";
    attributes1[3] = language == "ENG" ? "Power" : "Siła";
    attributes2[3] = language == "ENG" ? "Affection" : "Czułość";
    attributes3[3] = language == "ENG" ? "Family" : "Rodzina";
    attributes1[4] = language == "ENG" ? "Beauty" : "Power";
    attributes2[4] = language == "ENG" ? "Delicacy" : "Delikatność";
    attributes3[4] = language == "ENG" ? "Spirituality" : "Duchowość";
    attributes1[5] = language == "ENG" ? "Intelligence" : "Inteligencja";
    attributes2[5] = language == "ENG" ? "Flair" : "Spryt";
    attributes3[5] = language == "ENG" ? "Scrupulous" : "Sumienny";
    savingBackupShort = language == "ENG" ? "Saving backup" : "Zapis kopii";
    readingBackupShort = language == "ENG" ? "Reading backup" : "Odczyt kopii";
    savingBackupLong = language == "ENG" ? "Backup helps to care of your data.\n"
        "Moreover you can transfer app \n"
        "to other devices. It is recommended\n"
        "to do it atleast once a few days.\n"
        "It creates or overwrite the same file.\n\n"
        "Autosave: creates backup every entry to the app." :
    "Kopia pozwala zadbać o twoje dane.\n"
        "Ponadto mozesz zrobić transfer danych\n"
        "do innych urządzeń. Jest to zalecane\n"
        "wykonywać przynajmniej raz na kilka dni.\n"
        "Tworzy lub nadpisuje stworzony plik.\n\n"
        "Autozapis: tworzy kopię po każdym\n"
        "wejściu do aplikacji.";
    readingBackupLong = language == "ENG" ? "Reading backup helps transfer data.\n"
        "Remember to do it only if neccesary.\n"
        "All data will be overwritten." :
    "Odczyt kopii pomaga przetrasnferować dane.\n"
        "Pamietaj wykonywać to tylko gdy jest to konieczne.\n"
        "Wszystkie dane zostaną nadpisane";
    backupButton1 = language == "ENG" ? "Save to backup file" : "Zapisz kopię";
    backupButton2 = language == "ENG" ? "Read from backup file" : "Odczyt kopii";
    warningBackup = language == "ENG" ? "Opening file may cause losing your data. "
    "Dont change filename to make sure you are opening right file. "
        "Data are saved in Downloads and called hive_backup.json." :
    "Otwarcie pliku może spowodować utratę danych."
    "Nie zmieniaj nazwy pliku, aby mieć pewność, że otwierasz właściwy plik."
    "Dane są zapisywane w Pobranych plikach i nazywane są hive_backup.json.";
    warningTitle = language == "ENG" ? "Warning" : "Uwaga";
  }
}