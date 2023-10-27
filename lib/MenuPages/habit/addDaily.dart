import 'package:flutter/material.dart';
import 'package:flyhi/HiveClasses/DailyTodos.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class AddDaily extends StatefulWidget {
  const AddDaily({super.key, required this.editMode});

  final bool editMode;

  @override
  State<AddDaily> createState() => _AddDailyState();
}

class _AddDailyState extends State<AddDaily> {

  late Box dailyTodos;
  String _weightValue = 'wysoka';
  int _iconValue = 0;
  List<String> customImagePaths = List.generate(50, (index) => 'assets/images/ikona${index + 1}/32x32.png');
  List<int> availableColors = [
    0xFFD0312D,
    0xFFFF8700,
    0xFF01FF07,
    0xFF147DF5,
    0xFF580AFF,
    0xFFBE0AFF,
  ];
  int selectedColor = 0xFFFFF8B8;
  TextEditingController tec = TextEditingController();
  ScrollController _scrollController = ScrollController();

  void addDuty(){
    int weightValue = 0;
    if (_weightValue == 'wysoka' || _weightValue == 'high') {
      weightValue = 0;}
    else if (_weightValue == 'srednia' || _weightValue == 'medium') {
      weightValue = 1;}
    else if (_weightValue == 'niska' || _weightValue == 'low') {
      weightValue = 2;}
    DailyTodos dt = DailyTodos(tec.text, 'assets/images/ikona${_iconValue + 1}/128x128.png', "not done", DateTime.now(), weightValue, selectedColor);
    dailyTodos.add(dt);
  }

  @override
  void initState() {
    super.initState();
    dailyTodos = Hive.box('daily');
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: styles.classicFont),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){Navigator.pop(context,"false");}
        ),
        backgroundColor: styles.elementsInBg,
        title: Row(
          children: [
            Text(
              widget.editMode == false ? texts.addDailyAppBar : texts.modifyDailyAppBar,
              style: TextStyle(color: styles.classicFont,fontSize: 16),
            ),
            Spacer(), // Dodaj przerwę, aby przesunąć "Zapisz" na prawą stronę
            GestureDetector(
              onTap: () {
                setState(() {
                  addDuty();
                });
                Navigator.pop(context,"true");
              },
              child: Row(
                children: [
                  Text(texts.addDailySave, style: TextStyle(color: styles.classicFont,fontSize: 16)),
                  Icon(Icons.check, color: styles.classicFont,size: 18,),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Image.asset('assets/images/addTodo.png',fit: BoxFit.fitHeight,),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.addDailyName, // Lub 'Name' w zależności od języka
                          style: TextStyle(fontSize: 16, color: styles.classicFont),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                            color: styles.elementsInBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: tec,
                            style: TextStyle(color: styles.classicFont),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            textAlignVertical: TextAlignVertical.top, // Wyśrodkowanie tekstu tylko w pionie
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.addDailyImportance, // Lub 'Name' w zależności od języka
                          style: TextStyle(fontSize: 16, color: styles.classicFont),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: texts.addDailyImpList[0],
                                  groupValue: _weightValue, // Ustaw stan wyboru
                                  onChanged: (value) {
                                    setState(() {
                                      _weightValue = value!;
                                    });
                                  },
                                  activeColor: styles.classicFont,
                                  fillColor: MaterialStateColor.resolveWith((states) => styles.classicFont),
                                ),
                                Text(texts.addDailyImpList[0], style: TextStyle(fontSize: 14,
                                    color: styles.classicFont)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: texts.addDailyImpList[1],
                                  groupValue: _weightValue, // Ustaw stan wyboru
                                  onChanged: (value) {
                                    setState(() {
                                      _weightValue = value!;
                                    });
                                  },
                                  activeColor: styles.classicFont,
                                  fillColor: MaterialStateColor.resolveWith((states) => styles.classicFont),
                                ),
                                Text(texts.addDailyImpList[1], style: TextStyle(fontSize: 14,
                                    color: styles.classicFont)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: texts.addDailyImpList[2],
                                  groupValue: _weightValue, // Ustaw stan wyboru
                                  onChanged: (value) {
                                    setState(() {
                                      _weightValue = value!;
                                    });
                                  },
                                  activeColor: styles.classicFont,
                                  fillColor: MaterialStateColor.resolveWith((states) => styles.classicFont),
                                ),
                                Text(texts.addDailyImpList[2], style: TextStyle(fontSize: 14,
                                    color: styles.classicFont)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.addDailyIcon, // Lub 'Name' w zależności od języka
                          style: TextStyle(fontSize: 16, color: styles.classicFont),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 130,
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                              childAspectRatio: 1, // Stosunek szerokości do wysokości
                            ),
                            itemCount: customImagePaths.length,
                            controller: _scrollController,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _iconValue = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: _iconValue == index ?
                                        styles.elementsInBg : styles.mainBackgroundColor
                                  ),
                                  child: Image.asset(customImagePaths[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.addDailyTheme, // Lub 'Name' w zależności od języka
                          style: TextStyle(fontSize: 16, color: styles.classicFont),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int color in availableColors)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: selectedColor == color ? styles.elementsInBg : styles.mainBackgroundColor,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedColor = color; // Aktualizacja wybranego koloru
                                  });
                                },
                                child: Center(
                                  child: Container(
                                    height: 25, // Dostosuj wysokość wewnętrznego kształtu
                                    width: 25,  // Dostosuj szerokość wewnętrznego kształtu
                                    decoration: BoxDecoration(
                                      color: Color(color),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: styles.classicFont,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],),
        ),
      ),
    );
  }
}
