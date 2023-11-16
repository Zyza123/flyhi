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

  late List<int> fillweek = [];
  late List<int> filldays = [];

  void fillData(){
    fillweek.clear();
    filldays.clear();
    DateTime twodaysbefore = DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day).subtract(Duration(days: 2));
    fillweek.add(twodaysbefore.day);
    fillweek.add(twodaysbefore.add(Duration(days: 1)).day);
    fillweek.add(twodaysbefore.add(Duration(days: 2)).day);
    fillweek.add(twodaysbefore.add(Duration(days: 3)).day);
    fillweek.add(twodaysbefore.add(Duration(days: 4)).day);

    int day_week = twodaysbefore.weekday-1;
    for(int i = 0; i < 5; i++){
      if(day_week > 6){
        day_week = 0;
      }
      filldays.add(day_week);
      day_week++;
    }
  }

  BorderRadius _getBorderRadius(int index) {
    if (index == 1) {
      // Dla index = 1, dodaj border radius w dolnym prawym rogu
      return BorderRadius.only(bottomRight: Radius.circular(10.0));
    } else if (index == 3) {
      // Dla index = 3, dodaj border radius w dolnym lewym rogu
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children:  List.generate(fillweek.length, (index) {
                return Expanded(
                  child: Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: index == 2 ? styles.mainBackgroundColor: styles.elementsInBg,
                      borderRadius: _getBorderRadius(index),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${texts.homeDays[filldays[index]]}', // Wyświetlanie numeru dnia jako tekstu
                          style: TextStyle(fontSize: 20.0,
                              color: Color(0xFF4682B4),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${fillweek[index]}', // Wyświetlanie numeru dnia jako tekstu
                          style: TextStyle(fontSize: 20.0,
                              color: styles.classicFont,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
