
import 'package:flyhi/Language/Texts.dart';

class PolishTexts extends LanguageTexts{

  // Polish Translations
  late List<String> menu = ["Dom", "Nawyki", "Nagrody", "Ustawienia"];
  late List<String> homeDays = ["PON", "WT", "ŚR", "CZW", "PT", "SOB", "ND"];
  late String settingsDarkMode = "Tryb nocny";
  late String settingsLang = "Język";
  late List<String> langList = ["angielski", "polski"];
  late String settingsOffset = "Dzień zapasowy";
  late List<String> timeOffsetList = ["Brak", "1 godzina", "2 godziny", "3 godziny"];
  late String settingsReminder = "Przypomnienie";
  late List<String> reminderList = ["Bez przypomnienia", "minuty: 30"];
  late String settingsReminderNote = "Przypomnienie pozwala nie zapomnieć o ważnych wydarzeniach.\nPo zmianie czyści wszystkie powiadomienia (wyłączone) lub aktywuje obowiązki (włączone).\nPo włączeniu wymagany jest restart aplikacji.\nSprawdź pozwolenia powiadomień.";
  late String settingsDayOffset = "Przesunięcie doby";
  late String settingsDayOffsetNote = "Przesunięcie doby jest przydatne podczas późnego chodzenia spać.\nPo zmianie przesunięcia wymagany jest restart aplikacji.";
  late String todosMain = "AKTYWNOŚĆ";
  late String todosPickerDaily = "Dzienne";
  late String todosPickerHabits = "Nawyki";
  late String todosPlannedText = "Zaplanowane obowiązki";
  late String todosPopupEdit = "Edytuj ";
  late String todosPopupRemove = "Usuń ";
  late String todosPopupPostpone = "Przełóż ";
  late String habitsPopupEdit = "Edytuj ";
  late String habitsPopupRemove = "Usuń ";
  late String habitsPopupMinus = "Cofnij ";
  late String habitsAlertTitle = "Usuń";
  late String habitsAlertContent = "Na pewno chcesz usunąć obowiązek?";
  late String habitsAlertContentH = "Na pewno chcesz usunąć nawyk?";
  late String habitsAlertCancel = "Anuluj";
  late String habitsAlertConfirm = "Zatwierdź";
  late String todosHabits = "Moje nawyki";
  late List<String> todosFilterList = ["W kolejności dodania", "Waga malejąco", "Waga rosnąco", "Godzinowo"];
  late String addDailyAppBar = "Dodaj obowiązek";
  late String modifyDailyAppBar = "Modyfikuj obowiązek";
  late String addDailyName = "Nazwa";
  late String addDailyImportance = "Waga";
  late List<String> addDailyImpList = ["wysoka", "średnia", "niska"];
  late String addDailyHour = "Godzina";
  late String addDailyHourPickOther = "Wybierz inną";
  late String addDailyIcon = "Ikona";
  late String addDailyTheme = "Motyw";
  late String addSave = "Zapisz   ";
  late String addDailyAppearDay = "Data pojawienia";
  late String addDailyAppearToday = "Dzisiaj";
  late String addDailyAppearTomorrow = "Jutro";
  late String addHabitAppBar = "Dodaj nawyk";
  late String modifyHabitAppBar = "Modyfikuj nawyk";
  late String addHabitName = "Nazwa";
  late String addHabitDateOfAppearance = "Data rozpoczęcia";
  late String addHabitToday = "Dzisiaj";
  late String addHabitTomorrow = "Jutro";
  late String addHabitFrequency = "Częstotliwość";
  late String addHabitFrequencyWeek = "W tygodniu";
  late String addHabitPickDate = "Wybierz inną";
  late String addHabitLength = "Okres czasu";
  late String addHabitDays = "Dni";
  late String addHabitUndefined = "Nieokreślony";
  late String addHabitIcon = "Ikona";
  late String addHabitTheme = "Motyw";
  late List<String> habitsFilterList = ["W kolejności dodania", "Od najnowszych"];
  late String addHabitWarning = "Nie możesz poźniej zmienić jeśli dni przekraczają rok!";
  late String habitsFrequency = "Częstotliwość";
  late String habitsConn = "na";
  late String habitsProgress = "Postęp";
  late String habitsProgressDays = "dni";
  late String habitsStartDay = "Rozpoczęcie:";
  late String showFutureText = "Pokaż przyszłe nawyki";
  late String addThingWrongName = "* To pole jest wymagane";
  late String dayString = "dzień";
  late String daysString = "dni";
  late String achievementsTitle = "OSIĄGNIĘCIA";
  late List<String> achievementsTitleText = ["Wytrwały", "Waleczny", "Sumienny", "Niepokonany", "Opiekuńczy"];
  late List<String> achievementsMainText = ["Utrzymaj nawyk przez określoną ilość dni.", "Wypełnij określoną ilośc nawyków (min 50% efektywności).", "Wypełnij określoną ilość obowiązków.", "Osiągnij skuteczność wykonanego nawyku (minimum 30 dni).", "Podnieś poziom swojego pupila."];
  late String finishedHabitsName = "Ukończone nawyki";
  late String detailsHabitName = "Szczegóły nawyku";
  late String homeLevel = "Poziom";
  late String homeSelectButton = "WYBIERZ PUPILA";
  late String pickPetText = "Wybierz swojego pupila";
  late List<String> attributes1 = ["Siła", "Mądrość", "Lojalność", "Siła", "Power", "Inteligencja"];
  late List<String> attributes2 = ["Zwinność", "Zdrowie", "Przebiegłość", "Czułość", "Delikatność", "Spryt"];
  late List<String> attributes3 = ["Samodzielność", "Odwaga", "Współpraca", "Rodzina", "Duchowość", "Sumienny"];
  late String savingBackupShort = "Zapis kopii";
  late String savingBackupLong = "Kopia pozwala zadbać o twoje dane.\nPonadto mozesz zrobić transfer danych do innych urządzeń. Jest to zalecane wykonywać przynajmniej raz na kilka dni.\nTworzy lub nadpisuje stworzony plik.\n\nAutozapis: tworzy kopię po każdym wejściu do aplikacji.";
  late String readingBackupShort = "Odczyt kopii";
  late String readingBackupLong = "Odczyt kopii pomaga przetrasnferować dane.\nPamietaj wykonywać to tylko gdy jest to konieczne.\nWszystkie dane zostaną nadpisane.";
  late String backupButton1 = "Zapisz kopię";
  late String backupButton2 = "Odczyt kopii";
  late String warningBackup = "Otwarcie pliku może spowodować utratę danych.\nNie zmieniaj nazwy pliku, aby mieć pewność, że otwierasz właściwy plik.\nDane są zapisywane w Pobranych plikach i nazywane są hive_backup.json.";
  late String warningTitle = "Uwaga";
  late String changePetName = "Zmień nazwę zwierzaka";
  late String insertNewName = "Wpisz nową nazwę";
  late String fhTitle = "Usuwanie";
  late String fhText = "Czy na pewno chcesz usunąć nawyk z historii?";
  late String fhCancel = "Anuluj";
  late String fhDelete = "Usuń";

}