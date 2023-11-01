import 'package:flutter/material.dart';
import 'package:flyhi/HiveClasses/DailyTodos.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';
import 'dart:math';

import 'addDaily.dart';

enum SampleItem { edit, remove, postpone }

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {

  late int todo_mode;
  final mywidgetkey = GlobalKey();
  //List<String> dailyList = ["item1","item2","item3","item4","item5","item6","item7","item8","item9","item1","item2"];
  late Box dailyTodos;
  List<DailyTodos> todosCopy = [];
  List<int> indexListMirror = [];
  List<String> customImagePaths = List.generate(50, (index) => 'assets/images/ikona${index + 1}/128x128.png');
  int selectedFilter = 0;
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

  void addElementsToTodosAsc(){
    todosCopy.clear();
    indexListMirror.clear();
    int today = DateTime.now().day;
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < dailyTodos.length; j++){
        if(today == dailyTodos.getAt(j).date.day){
          if(dailyTodos.getAt(j).importance == i)
          todosCopy.add(dailyTodos.getAt(j));
          // print("dzien: "+dailyTodos.getAt(i).date.day.toString());
          indexListMirror.add(j);
        }
      }
    }
  }

  void addElementsToTodosDesc(){
    todosCopy.clear();
    indexListMirror.clear();
    int today = DateTime.now().day;
    for(int i = 2; i >= 0; i--){
      for(int j = 0; j < dailyTodos.length; j++){
        if(today == dailyTodos.getAt(j).date.day){
          if(dailyTodos.getAt(j).importance == i)
            todosCopy.add(dailyTodos.getAt(j));
          // print("dzien: "+dailyTodos.getAt(i).date.day.toString());
          indexListMirror.add(j);
        }
      }
    }
  }

  void addElementsToTodos(){
    todosCopy.clear();
    indexListMirror.clear();
    int today = DateTime.now().day;
    for(int i = 0; i < dailyTodos.length; i++){
      if(today == dailyTodos.getAt(i).date.day){
        todosCopy.add(dailyTodos.getAt(i));
       // print("dzien: "+dailyTodos.getAt(i).date.day.toString());
        indexListMirror.add(i);
      }
    }
  }

  void removeOldDates(){
    int today = DateTime.now().day;
    int tomorrow = DateTime.now().add(Duration(days: 1)).day;
    //print("dzisiaj 1: "+today.toString());
    //print("jutro 1: "+tomorrow.toString());
    List<dynamic> toRemove = [];
    for(int i = 0; i < dailyTodos.length; i++){
      if(today != dailyTodos.getAt(i).date.day && tomorrow != dailyTodos.getAt(i).date.day){
        toRemove.add(dailyTodos.keyAt(i));
        //dailyTodos.deleteAt(i);
      }
    }
    dailyTodos.deleteAll(toRemove);
    toRemove.clear();
  }

  void saveFilter(int filterIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('filter', filterIndex);
    // Możesz użyć innych metod, takich jak setInt(), setDouble(), itp., w zależności od rodzaju danych.
  }

  Future<void> readData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "filter";
    if(prefs.containsKey("filter")){
      setState(() {
        selectedFilter = prefs.getInt('filter')!;
        if(selectedFilter == 0){
          addElementsToTodos();
        }
        else if(selectedFilter == 1){
          addElementsToTodosAsc();
        }
        else{
          addElementsToTodosDesc();
        }
      });

    }

    // Możesz użyć innych metod, takich jak getInt(), getDouble(), itp., w zależności od rodzaju danych.
  }

  @override
  void initState() {
    super.initState();
    dailyTodos = Hive.box('daily');
    removeOldDates();
    readData();
    //dailyTodos.add(DailyTodos("dupa",'assets/images/ikona5/128x128.png', "not done", DateTime.now().subtract(Duration(days: 1)), 0, 0xFFD0312D,));
    //dailyTodos.clear();
    todo_mode = 0;
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
                    padding: const EdgeInsets.only(left: 20.0,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        todo_mode == 0 ? Text("${texts.todosPlannedText} :",
                          style: TextStyle(fontSize: 20,color: styles.classicFont),):
                        Text("${texts.todosHabits} :",
                          style: TextStyle(fontSize: 20,color: styles.classicFont),),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: styles.todosPickerOn,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(9),

                          ),
                          onPressed: ()  {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddDaily(editMode: false, editIndex: -1,)
                              )).then((value){
                                if(value == true) {
                                    setState(() {
                                      dailyTodos = Hive.box('daily');
                                      addElementsToTodos();
                                    });
                                  }
                            });
                          },
                          child: Icon(Icons.add, color: styles.classicFont,),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: styles.elementsInBg,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        dropdownColor: styles.elementsInBg,
                        isExpanded: true,
                        value: texts.todosFilterList[selectedFilter],
                        underline: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            print("filtr: $selectedFilter");
                            if(newValue == texts.todosFilterList[0]){
                              saveFilter(0);
                              selectedFilter = 0;
                              addElementsToTodos();
                            }
                            else if(newValue == texts.todosFilterList[1]){
                              saveFilter(1);
                              selectedFilter = 1;
                              addElementsToTodosAsc();
                            }
                            else if(newValue == texts.todosFilterList[2]){
                              saveFilter(2);
                              selectedFilter = 2;
                              addElementsToTodosDesc();
                            }
                          });
                        },
                        items: texts.todosFilterList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,style: TextStyle(color: styles.classicFont,fontSize: 17),),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  todo_mode == 0 ? Expanded( // Dodaj Expanded, aby rozciągnąć listę na dostępne miejsce
                    child: ListView.builder(
                    itemCount: todosCopy.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = todosCopy[index];
                      String defaultPlaceholderPath = 'assets/spinner.gif';
                      SampleItem? selectedMenu;
                      return Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: styles.elementsInBg,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 0),
                                      child: FadeInImage(
                                        height: 64,
                                        width: 64,
                                        key: ValueKey<String>(item.icon), // Generuj losowy klucz za każdym razem
                                        placeholder: AssetImage(item.icon),
                                        image: AssetImage(item.icon),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.name,
                                                  style: TextStyle(fontSize: 17, color: styles.classicFont),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              GestureDetector(
                                                 onTap: (){
                                                   var existingTodo = dailyTodos.getAt(indexListMirror[index]) as DailyTodos;
                                                   if(existingTodo.status == "not done"){
                                                     existingTodo.status = "done";
                                                   }
                                                   else{
                                                     existingTodo.status = "not done";
                                                   }
                                                   setState(() {
                                                     dailyTodos.putAt(indexListMirror[index], existingTodo);
                                                     todosCopy[index].status = existingTodo.status;
                                                   });
                                                 },
                                                 child: Icon(Icons.check, size: 25,
                                                   color: item.status == "done" ? Color(item.dailyTheme) : styles.classicFont,)
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 15,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                texts.addDailyImpList[item.importance],
                                                style: TextStyle(fontSize: 15, color: styles.classicFont),
                                              ),
                                              PopupMenuButton<SampleItem>(
                                                tooltip: "Show menu",
                                                color: styles.mainBackgroundColor,
                                                constraints: BoxConstraints(
                                                  maxWidth: 135,
                                                ),
                                                child: Container(
                                                  width: 25,
                                                  height: 25,
                                                  alignment: Alignment.bottomRight,
                                                  child: Icon(Icons.more_horiz, size: 25, color: styles.classicFont,),
                                                ),
                                                initialValue: selectedMenu,
                                                onSelected: (SampleItem item) {
                                                  if(item.index == 0){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => AddDaily(editMode: true, editIndex: indexListMirror[index],)
                                                        )).then((value){
                                                      if(value == true) {
                                                        setState(() {
                                                          dailyTodos = Hive.box('daily');
                                                          todosCopy[index] = dailyTodos.getAt(indexListMirror[index]);
                                                        });
                                                      }
                                                    });
                                                  }
                                                  else if(item.index == 1){
                                                    setState(() {
                                                      dailyTodos.deleteAt(
                                                        indexListMirror[index]
                                                      );
                                                      addElementsToTodos();
                                                    });
                                                  }
                                                  else if(item.index == 2){
                                                    var existingTodo = dailyTodos.getAt(indexListMirror[index]) as DailyTodos;
                                                    existingTodo.date = existingTodo.date.add(Duration(days: 1));
                                                    setState(() {
                                                      dailyTodos.putAt(indexListMirror[index], existingTodo);
                                                      addElementsToTodos();
                                                    });
                                                  }
                                                },
                                                itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                                                  PopupMenuItem<SampleItem>(
                                                    value: SampleItem.edit,
                                                    child: Container(
                                                      height: 40,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(texts.todosPopupEdit, style: TextStyle(color: styles.classicFont)),
                                                          Icon(Icons.edit_outlined, color: styles.classicFont),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  PopupMenuItem<SampleItem>(
                                                    value: SampleItem.remove,
                                                    child: Container(
                                                      height: 40,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(texts.todosPopupRemove, style: TextStyle(color: styles.classicFont)),
                                                          Icon(Icons.delete_outlined, color: styles.classicFont),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  PopupMenuItem<SampleItem>(
                                                    value: SampleItem.postpone,
                                                    child: Container(
                                                      height: 40,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(texts.todosPopupPostpone, style: TextStyle(color: styles.classicFont)),
                                                          Icon(Icons.access_alarm, color: styles.classicFont),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0), // Ustaw zaokrąglone rogi
                                    color: Colors.grey, // Kolor tła kontenera
                                  ),
                                  child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.decelerate,
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: item.status == "done" ? 1 : 0,
                                  ),
                                    builder: (context,value, _) =>
                                        LinearProgressIndicator(
                                          // Tu określ procent postępu (0.6 oznacza 60%)
                                          value: value,
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(item.dailyTheme)), // Tutaj możesz wybrać kolor
                                          backgroundColor: Colors.transparent, // Ustaw kolor tła na transparentny
                                          minHeight: 4, // Ustaw wysokość paska postępu (grubość)
                                        ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (index < dailyTodos.length - 1) Divider(color: styles.mainBackgroundColor,), // Dodaj Divider, jeśli to nie jest ostatni element listy
                        ],
                      );
                    },
                  ),
                  )
                      :
                  Expanded(child: Container(),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
