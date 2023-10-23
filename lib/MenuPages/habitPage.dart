import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Language/LanguageProvider.dart';
import '../Language/Texts.dart';
import '../Theme/DarkThemeProvider.dart';
import '../Theme/Styles.dart';
import 'dart:math';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {

  late int todo_mode;
  final mywidgetkey = GlobalKey();
  List<String> dailyList = ["item1","item2","item3","item4","item5","item6","item7","item8","item9","item1","item2"];

  //void updateProgressAndColor() {
  //  setState(() {
  //    progressValue = 1.0; // Ustaw na full (100%)
  //    final random = Random();
  //    progressBarColor = Color.fromARGB(
  //      255,
  //      random.nextInt(256),
  //      random.nextInt(256),
  //      random.nextInt(256),
  //    );
  //    checkboxColor = progressBarColor;
  //  });
  //}


  @override
  void initState() {
    super.initState();

    todo_mode = 0;
  }

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
        padding: EdgeInsets.only(top: 25),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    child: Text(texts.todosMain,style: TextStyle(
                        fontSize: 30,fontWeight: FontWeight.bold,color: styles.classicFont),),
                  ),
                  SizedBox(height: 30,),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0), // Zaokrąglone rogi
                        color: styles.todosPickerOff,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  todo_mode = 0;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150), // Czas trwania animacji
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0), // Zaokrąglone rogi
                                  color: todo_mode == 0 ? styles.todosPickerOn : styles.todosPickerOff,
                                ),
                                child: Center(
                                  child: Text(
                                    texts.todosPickerDaily,
                                    style: TextStyle(fontSize: 20,color: styles.classicFont),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  todo_mode = 1;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150), // Czas trwania animacji
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0), // Zaokrąglone rogi
                                  color: todo_mode == 1 ? styles.todosPickerOn : styles.todosPickerOff,
                                ),
                                child: Center(
                                  child: Text(
                                    texts.todosPickerHabits,
                                    style: TextStyle(fontSize: 20,color: styles.classicFont),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("${texts.todosPlannedText} :",
                        style: TextStyle(fontSize: 20,color: styles.classicFont),),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Expanded( // Dodaj Expanded, aby rozciągnąć listę na dostępne miejsce
                    child: ListView.builder(
                    itemCount: dailyList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: styles.elementsInBg,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.accessibility_outlined, size: 60, color: styles.classicFont,),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                dailyList[index],
                                                style: TextStyle(fontSize: 18, color: styles.classicFont),
                                              ),
                                              Icon(Icons.check, size: 25, color: styles.classicFont,)
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "important",
                                                style: TextStyle(fontSize: 15, color: styles.classicFont),
                                              ),
                                              Icon(Icons.more_horiz, size: 25, color: styles.classicFont,)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                LinearProgressIndicator(
                                  value: 0.6, // Tu określ procent postępu (0.6 oznacza 60%)
                                  valueColor: AlwaysStoppedAnimation<Color>(styles.todosPickerOn), // Tutaj możesz wybrać kolor
                                  backgroundColor: Colors.grey, // Kolor tła paska postępu
                                )
                              ],
                            ),
                          ),
                          if (index < dailyList.length - 1) Divider(color: styles.mainBackgroundColor,), // Dodaj Divider, jeśli to nie jest ostatni element listy
                        ],
                      );
                    },
                  ),
                  ),
                ],
              ),
              Positioned(
                key: mywidgetkey,
                bottom: 15,
                right: 0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: styles.todosPickerOn,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(9),
                  ),
                  onPressed: () {},
                  child: Icon(Icons.add, color: styles.classicFont,),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
