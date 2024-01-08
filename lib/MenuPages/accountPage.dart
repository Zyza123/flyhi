import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flyhi/Language/LanguageProvider.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../HiveClasses/Achievements.dart';
import '../HiveClasses/DailyTodos.dart';
import '../HiveClasses/HabitArchive.dart';
import '../HiveClasses/HabitTodos.dart';
import '../HiveClasses/Pets.dart';
import '../Language/Texts.dart';
import '../Notification/NotificationManager.dart';
import '../Storage/FileStorage.dart';
import '../Theme/DarkThemeProvider.dart';
import '../Theme/Styles.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  // Metoda do zapisu przesunięcia czasu do SharedPreferences
  void saveOffsetToPrefs(int offset) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('DAY_OFFSET', offset);
    day_offsetNotifier.value = offset;
  }

  Future<void> getOffsetFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    day_offset = prefs.getInt('DAY_OFFSET') ?? 0;
    day_offsetNotifier.value = day_offset;
  }

  void saveRemindToPrefs(int remind) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('REMINDER', remind);
    reminderNotifier.value = remind;
  }

  Future<void> getRemindFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reminder = prefs.getInt('REMINDER') ?? 0;
    reminderNotifier.value = reminder;
  }

  void saveAutosaveToPrefs(bool save) async {
    autocopy = save;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('AUTOSAVE', save);
  }

  Future<void> getAutosaveFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    autocopy = prefs.getBool('AUTOSAVE') ?? false;
    autosaveNotifier = ValueNotifier(autocopy);
    if(autocopy){
      saveDataToFile();
    }
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    }
    return true;
  }

  Future<String?> pickAndReadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      File file = File(filePath);
      String basename1 = basename(file.path);
      print("Basename: " + basename1);
      if(basename1 == "hive_backup.json"){
        String fileContent = await file.readAsString();
        return fileContent;
      }
    } else {
      // Użytkownik anulował wybór pliku lub ścieżka jest nieważna
      return null;
    }
  }

  Future<bool> showConfirmationDialog(BuildContext context,String warningBackup,
      String cancel, String accept, String warningTitle, Color font, Color bg) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(warningTitle,style: TextStyle(color: font),),
        content: Text(warningBackup,style: TextStyle(color: font),),
        backgroundColor: bg,
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancel,style: TextStyle(color: font),),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(accept,style: TextStyle(color: font),),
              ),
            ],
          ),
        ],
      ),
    ) ?? false; // Zwraca false, jeśli dialog zostanie zamknięty inaczej
  }

  Future<Map<String, dynamic>> collectHiveData() async {
    // Otwórz skrzynki
    var achievementsBox = Hive.box('achievements');
    var dailyTodosBox = Hive.box('daily');
    var habitArchiveBox = Hive.box('habitsArchive');
    var habitTodosBox = Hive.box('habits');
    var petsBox = Hive.box('pets');

    // Konwersja danych do JSON
    List<Map<String, dynamic>> achievementsData = achievementsBox.values
        .cast<Achievements>()
        .map((achievement) => achievement.toJson())
        .toList();

    List<Map<String, dynamic>> dailyTodosData = dailyTodosBox.values
        .cast<DailyTodos>()
        .map((todo) => todo.toJson())
        .toList();

    List<Map<String, dynamic>> habitArchiveData = habitArchiveBox.values
        .cast<HabitArchive>()
        .map((archive) => archive.toJson())
        .toList();

    List<Map<String, dynamic>> habitTodosData = habitTodosBox.values
        .cast<HabitTodos>()
        .map((todo) => todo.toJson())
        .toList();

    List<Map<String, dynamic>> petsData = petsBox.values
        .cast<Pets>()
        .map((pet) => pet.toJson())
        .toList();

    return {
      'achievements': achievementsData,
      'dailyTodos': dailyTodosData,
      'habitArchive': habitArchiveData,
      'habitTodos': habitTodosData,
      'pets': petsData,
    };
  }

  Future<void> loadHiveDataFromJson(String jsonData) async {
    var decodedData = jsonDecode(jsonData);

    // Wczytywanie danych do skrzynki 'achievements'
    if (decodedData['achievements'] != null) {
      var achievementsBox = Hive.box('achievements');
      await achievementsBox.clear();
      for (var achievementJson in decodedData['achievements']) {
        var achievement = Achievements.fromJson(achievementJson);
        await achievementsBox.add(achievement);
      }
    }

    // Wczytywanie danych do skrzynki 'dailyTodos'
    if (decodedData['dailyTodos'] != null) {
      var dailyTodosBox =  Hive.box('daily');
      await dailyTodosBox.clear();
      for (var dailyTodoJson in decodedData['dailyTodos']) {
        var dailyTodo = DailyTodos.fromJson(dailyTodoJson);
        await dailyTodosBox.add(dailyTodo);
      }
    }

    // Wczytywanie danych do skrzynki 'habitArchive'
    if (decodedData['habitsArchive'] != null) {
      var habitArchiveBox = Hive.box('habitsArchive');
      await habitArchiveBox.clear();
      for (var archiveJson in decodedData['habitArchive']) {
        var archive = HabitArchive.fromJson(archiveJson);
        await habitArchiveBox.add(archive);
      }
    }

    // Wczytywanie danych do skrzynki 'habitTodos'
    if (decodedData['habitTodos'] != null) {
      var habitTodosBox = Hive.box('habits');
      await habitTodosBox.clear();
      for (var todoJson in decodedData['habitTodos']) {
        var todo = HabitTodos.fromJson(todoJson);
        await habitTodosBox.add(todo);
      }
    }

    // Wczytywanie danych do skrzynki 'pets'
    if (decodedData['pets'] != null) {
      var petsBox = Hive.box('pets');
      await petsBox.clear();
      for (var petJson in decodedData['pets']) {
        var pet = Pets.fromJson(petJson);
        await petsBox.add(pet);
      }
    }
  }

  void saveDataToFile() async {
    Map<String, dynamic> hiveData = await collectHiveData();
    String jsonString = jsonEncode(hiveData);
    await FileStorage.writeCounter(jsonString, 'hive_backup.json');
  }

  int day_offset = 0;
  ValueNotifier<int> day_offsetNotifier = ValueNotifier(0);
  int reminder = 0;
  ValueNotifier<int> reminderNotifier = ValueNotifier(0);
  bool autocopy = false;
  ValueNotifier<bool> autosaveNotifier = ValueNotifier(false);
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  initState(){
    super.initState();
  }

  @override
  void dispose() {
    autosaveNotifier.dispose();
    day_offsetNotifier.dispose();
    reminderNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final langChange = Provider.of<LanguageProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    Texts texts = Texts();
    texts.setTextLang(langChange.language);

    return FutureBuilder(
      future: Future.wait([getOffsetFromPrefs(),getRemindFromPrefs(),getAutosaveFromPrefs()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: Scaffold(
              backgroundColor: styles.mainBackgroundColor,
              body: Padding(
                padding: const EdgeInsets.only(left: 20.0,right:20,top: 25,bottom: 5),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(texts.menu[3].toUpperCase(),style: TextStyle(
                              fontSize: 30,fontWeight: FontWeight.bold,color: styles.classicFont),),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(texts.settingsDarkMode,style: TextStyle(
                                color: styles.classicFont,fontSize: 18,),),
                            ),
                            Switch(
                              //activeColor: styles.switchColors,
                              //inactiveThumbColor: styles.switchColors,
                              value: themeChange.darkTheme,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  themeChange.darkTheme = value;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                texts.settingsLang,
                                style: TextStyle(
                                  color: styles.classicFont,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: langChange.language == "ENG" ? "english": "polski",
                                dropdownColor: styles.menuBg,
                                items: texts.langList.map((String language) {
                                  return DropdownMenuItem<String>(
                                    value: language,
                                    child: Text(language,style: TextStyle(color: styles.classicFont),),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    if(newValue == "english" || newValue == "angielski"){
                                      langChange.language = "ENG";
                                    }
                                    else{
                                      langChange.language = "PL";
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                texts.settingsDayOffset,
                                style: TextStyle(
                                  color: styles.classicFont,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: day_offsetNotifier,
                              builder: (context, value, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: texts.timeOffsetList[value],
                                    dropdownColor: styles.menuBg,
                                    items: texts.timeOffsetList.map((String offset) {
                                      return DropdownMenuItem<String>(
                                        value: offset,
                                        child: Text(offset,style: TextStyle(color: styles.classicFont),),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      int selectedIndex = texts.timeOffsetList.indexOf(newValue!);
                                      saveOffsetToPrefs(selectedIndex);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.settingsDayOffsetNote,
                          style: TextStyle(
                            color: styles.fontMenuOff,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                texts.settingsReminder,
                                style: TextStyle(
                                  color: styles.classicFont,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: reminderNotifier,
                              builder: (context, value, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: texts.reminderList[value],
                                    dropdownColor: styles.menuBg,
                                    items: texts.reminderList.map((String remind) {
                                      return DropdownMenuItem<String>(
                                        value: remind,
                                        child: Text(remind,style: TextStyle(color: styles.classicFont),),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      int selectedIndex = texts.reminderList.indexOf(newValue!);
                                      saveRemindToPrefs(selectedIndex);
                                      if(selectedIndex == 0){
                                        NotificationManager().flutterLocalNotificationsPlugin.cancelAll();
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.settingsReminderNote,
                          style: TextStyle(
                            color: styles.fontMenuOff,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.savingBackupShort,
                          style: TextStyle(
                            color: styles.classicFont,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.savingBackupLong,
                          style: TextStyle(
                            color: styles.fontMenuOff,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: autosaveNotifier,
                            builder: (context, value, child) {
                              return Switch(
                                value: value,
                                onChanged: (newValue) {
                                  autosaveNotifier.value = newValue;
                                  saveAutosaveToPrefs(newValue);
                                },
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (await requestStoragePermission()) {
                                saveDataToFile();
                                SnackBar snackBar = SnackBar(
                                  content: Text('File saved succesfully!',style: TextStyle(
                                    color: styles.classicFont
                                  ),),
                                  backgroundColor: styles.whiteBlack.withOpacity(0.9),
                                  action: SnackBarAction(
                                    label: 'dismiss',
                                    textColor: styles.classicFont,
                                    onPressed: () {
                                    },
                                  ),
                                );
                                scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
                              } else {
                                SnackBar snackBar = SnackBar(
                                  content: Text('Cannot write, check permissions!',style: TextStyle(
                                      color: styles.classicFont
                                  ),),
                                  backgroundColor: styles.whiteBlack.withOpacity(0.9),
                                  action: SnackBarAction(
                                    label: 'dismiss',
                                    textColor: styles.classicFont,
                                    onPressed: () {
                                    },
                                  ),
                                );
                                scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: styles.classicFont, backgroundColor: styles.whiteBlack, // Text color
                              side: BorderSide(color: styles.classicFont, width: 1.0), // Border color and width
                            ),
                            child: Text(texts.backupButton1),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.readingBackupShort,
                          style: TextStyle(
                            color: styles.classicFont,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.readingBackupLong,
                          style: TextStyle(
                            color: styles.fontMenuOff,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed: () async {
                          bool confirm = await showConfirmationDialog(context,texts.warningBackup,
                            texts.habitsAlertCancel,texts.habitsAlertConfirm,texts.warningTitle,
                              styles.classicFont, styles.elementsInBg);
                          if (confirm) {
                            String? jsonString = await pickAndReadFile();
                            print(jsonString);
                            if (jsonString != null) {
                              loadHiveDataFromJson(jsonString);
                              SnackBar snackBar = SnackBar(
                                content: Text('Succesfully imported data!\nRestart the app!',style: TextStyle(
                                    color: styles.classicFont
                                ),),
                                backgroundColor: styles.whiteBlack.withOpacity(0.9),
                                action: SnackBarAction(
                                  label: 'dismiss',
                                  textColor: styles.classicFont,
                                  onPressed: () {
                                  },
                                ),
                              );
                              scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
                            } else {
                              SnackBar snackBar = SnackBar(
                                content: Text('Bad file or the file is empty!',style: TextStyle(
                                    color: styles.classicFont
                                ),),
                                backgroundColor: styles.whiteBlack.withOpacity(0.9),
                                action: SnackBarAction(
                                  label: 'dismiss',
                                  textColor: styles.classicFont,
                                  onPressed: () {
                                  },
                                ),
                              );
                              scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
                              print('Nie wybrano pliku lub plik jest pusty');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: styles.classicFont, backgroundColor: styles.whiteBlack, // Text color
                          side: BorderSide(color: styles.classicFont, width: 1.0), // Border color and width
                        ),
                        child: Text(texts.backupButton2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator(color: styles.classicFont,);
        }
      },
    );
  }
}
