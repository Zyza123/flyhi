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

  BorderRadius _getBorderRadius(int index) {
    if (index == 0) {
      // Dla pierwszego elementu, dodaj border radius w dolnym prawym rogu
      return BorderRadius.only(bottomRight: Radius.circular(10.0));
    } else if (index == 6) {
      // Dla ostatniego elementu, dodaj border radius w dolnym lewym rogu
      return BorderRadius.only(bottomLeft: Radius.circular(10.0));
    } else {
      // Dla innych przypadków, brak border radius
      return BorderRadius.zero;
    }
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0,left: 5,right: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(weekDates.length, (index) {
              return GestureDetector(
                onTap: () {
                  print('Wybrano dzień: ${weekDates[index]}');
                  setState(() {
                  selectedDay = index;
                  });
                },
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: index == selectedDay
                        ? styles.dateColor // Dzisiaj
                        : styles.mainBackgroundColor, // Pozostałe dni
                    borderRadius: index == selectedDay
                      ? BorderRadius.circular(10):
                        BorderRadius.zero
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${weekDates[index].day}',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: styles.classicFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${texts.homeDays[fillweek[index]]}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: styles.classicFont,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
