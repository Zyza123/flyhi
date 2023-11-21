import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Language/LanguageProvider.dart';
import '../Language/Texts.dart';
import '../Theme/DarkThemeProvider.dart';
import '../Theme/Styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<DateTime> weekDates = [];
  late List<int> fillweek = [];
  late int selectedDay;

  void fillData() {
    weekDates.clear();
    fillweek.clear();
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      weekDates.add(today.add(Duration(days: i)));
      fillweek.add(weekDates[i].weekday - 1);
    }
    selectedDay = 0;
  }

  @override
  void initState() {
    fillData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    final langChange = Provider.of<LanguageProvider>(context);
    Texts texts = Texts();
    texts.setTextLang(langChange.language);
    return Scaffold(
      backgroundColor: styles.mainBackgroundColor,
      body: Container()
    );
  }
}
