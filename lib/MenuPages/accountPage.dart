import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flyhi/Language/LanguageProvider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../HiveClasses/Achievements.dart';
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
  }

  Future<void> getOffsetFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    day_offset = prefs.getInt('DAY_OFFSET') ?? 0;
  }

  void saveRemindToPrefs(int offset) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('REMINDER', offset);
  }

  Future<void> getRemindFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reminder = prefs.getInt('REMINDER') ?? 0;
  }

  Future<Map<String, dynamic>> collectHiveData() async {
    var achievementsBox = Hive.box('achievements');

    // Konwersja każdego obiektu Achievements do Mapy, która może być zakodowana do JSON
    List<Map<String, dynamic>> achievementsData = achievementsBox.values
        .cast<Achievements>() // Upewnij się, że masz do czynienia z obiektami Achievements
        .map((achievement) => achievement.toJson()) // Użyj metody toJson zdefiniowanej w klasie Achievements
        .toList();

    return {
      'achievements': achievementsData,
    };
  }

  void saveDataToFile() async {
    Map<String, dynamic> hiveData = await collectHiveData();
    String jsonString = jsonEncode(hiveData);
    await FileStorage.writeCounter(jsonString, 'hive_backup.json');
  }

  late int day_offset;
  late int reminder;

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const myList = {
      "name":"GeeksForGeeks1122"
    };
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final langChange = Provider.of<LanguageProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    Texts texts = Texts();
    texts.setTextLang(langChange.language);

    return FutureBuilder(
      future: Future.wait([getOffsetFromPrefs(),getRemindFromPrefs()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: styles.mainBackgroundColor,
            body: Padding(
              padding: const EdgeInsets.only(left: 20.0,right:20,top: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
                            activeColor: styles.switchColors,
                            inactiveThumbColor: styles.switchColors,
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
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: texts.timeOffsetList[day_offset],
                              dropdownColor: styles.menuBg,
                              items: texts.timeOffsetList.map((String offset) {
                                return DropdownMenuItem<String>(
                                  value: offset,
                                  child: Text(offset,style: TextStyle(color: styles.classicFont),),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                int selectedIndex = texts.timeOffsetList.indexOf(newValue!);
                                setState(() {
                                  saveOffsetToPrefs(selectedIndex);
                                });
                              },
                            ),
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
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: texts.reminderList[reminder],
                              dropdownColor: styles.menuBg,
                              items: texts.reminderList.map((String remind) {
                                return DropdownMenuItem<String>(
                                  value: remind,
                                  child: Text(remind,style: TextStyle(color: styles.classicFont),),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                int selectedIndex = texts.reminderList.indexOf(newValue!);
                                setState(() {
                                  saveRemindToPrefs(selectedIndex);
                                  if(selectedIndex == 0){
                                    NotificationManager().flutterLocalNotificationsPlugin.cancelAll();
                                  }
                                });
                              },
                            ),
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
                    ElevatedButton(
                        onPressed: (){
                          saveDataToFile();
                        },
                        child: Text("Save file")),
                  ],
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
