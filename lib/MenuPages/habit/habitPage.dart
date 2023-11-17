import 'package:flutter/material.dart';
import 'package:flyhi/HiveClasses/DailyTodos.dart';
import 'package:flyhi/HiveClasses/HabitTodos.dart';
import 'package:flyhi/MenuPages/habit/addHabit.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../HiveClasses/Achievements.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';
import 'dart:math';

import 'addDaily.dart';

enum SampleItem { edit, remove, postpone }
enum SampleItemHabit {edit, remove, minus }

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {

  late int todo_mode;
  late Box dailyTodos;
  List<DailyTodos> todosCopy = [];
  List<int> indexListMirror = [];
  int selectedTodoFilter = 0;
  int selectedHabitFilter = 0;

  late Box habitsTodos;
  late Box achievements;
  late Box habitsArchive;
  List<HabitTodos> habitsCopy = [];
  List<int> indexListHabitsMirror = [];


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

  void addElementsToHabits(){
    // co jeszcze brakuje
    // dodanie usuwania starych nawyków które się już skończyły i dodanie ich danych całych do
    // klasy z osiągnięciami gdy już będzie stworzona

    habitsCopy.clear();
    indexListHabitsMirror.clear();
    for(int i = 0; i < habitsTodos.length; i++)
    {
      HabitTodos existingHabit = habitsTodos.getAt(i);
      DateTime today = DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day);
      if(today.isAfter(existingHabit.date) || today.isAtSameMomentAs(existingHabit.date)){
        DateTime before = existingHabit.efficiency.keys.last;
        DateTime week_before = today.subtract(Duration(days: 7));
        int days_dif = (today.difference(before).inHours/24).ceil() + 1;
        if(existingHabit.dayNumber <= existingHabit.fullTime){
          existingHabit.dayNumber = days_dif;
        }
        if(week_before.isAtSameMomentAs(before) || week_before.isAfter(before)){
          existingHabit.efficiency[today] = 0.0;
        }
        habitsTodos.putAt(i, existingHabit);
        habitsCopy.add(habitsTodos.getAt(i));
        indexListHabitsMirror.add(i);
      }
    }
  }

  // remove all old habits and add them to archive
  void removeOldHabits(){
    List<dynamic> toRemove = [];
    for(int i = habitsTodos.length -1; i >= 0; i--)
    {
      var existingHabit = habitsTodos.getAt(i);
      DateTime today = DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day);
      if(today.isAfter(existingHabit.date) || today.isAtSameMomentAs(existingHabit.date)){
        if(existingHabit.dayNumber > existingHabit.fullTime){
          HabitTodos ht = habitsTodos.getAt(i);
          ht.dayNumber -= 1;
          habitsArchive.add(ht);
          toRemove.add(habitsTodos.keyAt(i));
        }
      }
    }
    habitsTodos.deleteAll(toRemove);
    toRemove.clear();
  }

  void addElementsToHabitsByNew(){
    // co jeszcze brakuje
    // dodanie usuwania starych nawyków które się już skończyły i dodanie ich danych całych do
    // klasy z osiągnięciami gdy już będzie stworzona
    habitsCopy.clear();
    indexListHabitsMirror.clear();
    for(int i = habitsTodos.length -1; i >= 0; i--)
    {
      var existingHabit = habitsTodos.getAt(i);
      DateTime today = DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day);
      if(today.isAfter(existingHabit.date) || today.isAtSameMomentAs(existingHabit.date)){
        DateTime before = existingHabit.efficiency.keys.last;
        DateTime week_before = today.subtract(Duration(days: 7));
        int days_dif = (today.difference(before).inHours/24).ceil() + 1;
        if(existingHabit.dayNumber <= existingHabit.fullTime){
          existingHabit.dayNumber = days_dif;
        }
        if(week_before.isAtSameMomentAs(before) || week_before.isAfter(before)){
          existingHabit.efficiency[today] = 0.0;
        }
        habitsTodos.putAt(i, existingHabit);
        habitsCopy.add(habitsTodos.getAt(i));
        indexListHabitsMirror.add(i);
      }
    }
  }

  void removeOldDates(){
    int today = DateTime.now().day;
    int tomorrow = DateTime.now().add(Duration(days: 1)).day;
    //print("dzisiaj 1: "+today.toString());
    //print("jutro 1: "+tomorrow.toString());
    List<dynamic> toRemove = [];
    int points_counter = 0;
    for(int i = 0; i < dailyTodos.length; i++){
      if(today != dailyTodos.getAt(i).date.day && tomorrow != dailyTodos.getAt(i).date.day){
        toRemove.add(dailyTodos.keyAt(i));
        if(dailyTodos.getAt(i).status == "done"){
          points_counter++;
        }
      }
    }
    // dodawanie do osiągnieć punktów ze zdobytych obowiazkow
    Achievements ach = achievements.getAt(2);
    ach.value += points_counter;
    while(ach.value > ach.level[ach.progress]){
      ach.progress += 1;
    }
    achievements.putAt(2, ach);
    dailyTodos.deleteAll(toRemove);
    toRemove.clear();
  }

  void saveTodoFilter(int filterIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('filter', filterIndex);
    // Możesz użyć innych metod, takich jak setInt(), setDouble(), itp., w zależności od rodzaju danych.
  }

  Future<void> readTodoData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "filter";
    if(prefs.containsKey("filter")){
      setState(() {
        selectedTodoFilter = prefs.getInt('filter')!;
        if(selectedTodoFilter == 0){
          addElementsToTodos();
        }
        else if(selectedTodoFilter == 1){
          addElementsToTodosAsc();
        }
        else{
          addElementsToTodosDesc();
        }
      });
    }
  }
  void saveHabitFilter(int filterIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('habitFilter', filterIndex);
    // Możesz użyć innych metod, takich jak setInt(), setDouble(), itp., w zależności od rodzaju danych.
  }

  Future<void> readHabitData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "habitFilter";
    if(prefs.containsKey("habitFilter")){
      setState(() {
        selectedHabitFilter = prefs.getInt('habitFilter')!;
        if(selectedHabitFilter == 0){
          addElementsToHabits();
        }
        else{
          addElementsToHabitsByNew();
        }
      });
    }
  }


  @override
  void initState() {
    super.initState();
    dailyTodos = Hive.box('daily');
    achievements = Hive.box('achievements');
    removeOldDates();
    habitsTodos = Hive.box('habits');
    habitsArchive = Hive.box('habitsArchive');
    removeOldHabits();
    readTodoData();
    readHabitData();
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
                            todo_mode == 0 ? Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddDaily(editMode: false, editIndex: -1,)
                              )).then((value){
                                if(value == true) {
                                    setState(() {
                                      readTodoData();
                                    });
                                  }
                            })
                            :
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddHabit(editMode: false, editIndex: -1,))
                            ).then((value){
                              if(value == true) {
                                setState(() {
                                  readHabitData();
                                });
                              }
                            });
                          },
                          child: Icon(Icons.add, color: styles.classicFont,),
                        ),

                      ],
                    ),
                  ),
                  todo_mode == 0 ? Container(
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
                        value: texts.todosFilterList[selectedTodoFilter],
                        underline: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            print("filtr: $selectedTodoFilter");
                            if(newValue == texts.todosFilterList[0]){
                              saveTodoFilter(0);
                              selectedTodoFilter = 0;
                              addElementsToTodos();
                            }
                            else if(newValue == texts.todosFilterList[1]){
                              saveTodoFilter(1);
                              selectedTodoFilter = 1;
                              addElementsToTodosAsc();
                            }
                            else if(newValue == texts.todosFilterList[2]){
                              saveTodoFilter(2);
                              selectedTodoFilter = 2;
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
                  ):
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
                        value: texts.habitsFilterList[selectedHabitFilter],
                        underline: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            if(newValue == texts.habitsFilterList[0]){
                              saveHabitFilter(0);
                              selectedHabitFilter = 0;
                              addElementsToHabits();
                            }
                            else if(newValue == texts.habitsFilterList[1]){
                              saveHabitFilter(1);
                              selectedHabitFilter = 1;
                              addElementsToHabitsByNew();
                            }
                          });
                        },
                        items: texts.habitsFilterList
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
                  todo_mode == 0 ? Expanded(
                    child: ListView.builder(
                    itemCount: todosCopy.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = todosCopy[index];
                      String defaultPlaceholderPath = 'assets/spinner.gif';
                      double colored = item.status == "done" ? 1 : 0;
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
                                    FadeInImage(
                                      height: 64,
                                      width: 64,
                                      key: ValueKey<AssetImage>(AssetImage(item.icon)), // Generuj losowy klucz za każdym razem
                                      placeholder: const AssetImage('assets/empty.png'),
                                      image: AssetImage(item.icon),
                                      fit: BoxFit.contain,
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
                                              PopupMenuButton<SampleItem>(
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
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text(texts.habitsAlertTitle,style: TextStyle(color: styles.classicFont),),
                                                          content: Text(texts.habitsAlertContent,style: TextStyle(color: styles.classicFont),),
                                                          backgroundColor: styles.elementsInBg,
                                                          actionsAlignment: MainAxisAlignment.spaceAround,
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(context); // Zamknij AlertDialog
                                                              },
                                                              child: Text(texts.habitsAlertCancel,style: TextStyle(color: styles.classicFont),),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                // Usuń element i zamknij AlertDialog
                                                                setState(() {
                                                                  dailyTodos.deleteAt(
                                                                      indexListMirror[index]);
                                                                  readTodoData();
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text(texts.habitsAlertConfirm,style: TextStyle(color: styles.classicFont),),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
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
                                          ),
                                          SizedBox(height: 15,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${texts.addDailyImportance.toLowerCase()}: ${texts.addDailyImpList[item.importance]}",
                                                style: TextStyle(fontSize: 15, color: styles.classicFont),
                                              ),
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
                                  key: Key("1"),
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.decelerate,
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: colored,
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
                  Expanded(
                      child: ListView.builder(
                        itemCount: habitsCopy.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = habitsCopy[index];
                          double week_value = item.efficiency.values.last;
                          DateTime week_key = item.efficiency.keys.last;
                          SampleItemHabit? selectedMenu;
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
                                        FadeInImage(
                                          height: 64,
                                          width: 64,
                                          key: ValueKey<AssetImage>(AssetImage(item.icon)), // Generuj losowy klucz za każdym razem
                                          placeholder: const AssetImage('assets/empty.png'),
                                          image: AssetImage(item.icon),
                                          fit: BoxFit.contain,
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
                                                  PopupMenuButton<SampleItemHabit>(
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
                                                    onSelected: (SampleItemHabit item1) {
                                                      if(item1.index == 0){
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => AddHabit(editMode: true, editIndex: indexListHabitsMirror[index],)
                                                            )).then((value){
                                                          if(value == true) {
                                                            setState(() {
                                                              habitsTodos = Hive.box('habits');
                                                              habitsCopy[index] = habitsTodos.getAt(indexListHabitsMirror[index]);
                                                            });
                                                          }
                                                        });
                                                      }
                                                      else if(item1.index == 1){
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text(texts.habitsAlertTitle,style: TextStyle(color: styles.classicFont),),
                                                              content: Text(texts.habitsAlertContentH,style: TextStyle(color: styles.classicFont),),
                                                              backgroundColor: styles.elementsInBg,
                                                              actionsAlignment: MainAxisAlignment.spaceAround,
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(context); // Zamknij AlertDialog
                                                                  },
                                                                  child: Text(texts.habitsAlertCancel,style: TextStyle(color: styles.classicFont),),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    // Usuń element i zamknij AlertDialog
                                                                    setState(() {
                                                                      habitsTodos.deleteAt(
                                                                          indexListHabitsMirror[index]
                                                                      );
                                                                      readHabitData();
                                                                    });
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text(texts.habitsAlertConfirm,style: TextStyle(color: styles.classicFont),),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                      else if(item1.index == 2){
                                                        var existingHabit = habitsTodos.getAt(indexListHabitsMirror[index]) as HabitTodos;
                                                        DateTime dtKey = existingHabit.efficiency.keys.last;
                                                        double dtValue = existingHabit.efficiency.values.last;
                                                        if(existingHabit.efficiency[dtKey]! > 0){
                                                          existingHabit.efficiency[dtKey] = dtValue - 1;
                                                          setState(() {
                                                            habitsTodos.putAt(indexListHabitsMirror[index], existingHabit);
                                                            item.efficiency[dtKey] = dtValue - 1;
                                                          });
                                                        }
                                                      }
                                                    },
                                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItemHabit>>[
                                                      PopupMenuItem<SampleItemHabit>(
                                                        value: SampleItemHabit.edit,
                                                        child: Container(
                                                          height: 40,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(texts.habitsPopupEdit, style: TextStyle(color: styles.classicFont)),
                                                              Icon(Icons.edit_outlined, color: styles.classicFont),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      PopupMenuItem<SampleItemHabit>(
                                                        value: SampleItemHabit.remove,
                                                        child: Container(
                                                          height: 40,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(texts.habitsPopupRemove, style: TextStyle(color: styles.classicFont)),
                                                              Icon(Icons.delete_outlined, color: styles.classicFont),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      PopupMenuItem<SampleItemHabit>(
                                                        value: SampleItemHabit.minus,
                                                        child: Container(
                                                          height: 40,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(texts.habitsPopupMinus, style: TextStyle(color: styles.classicFont)),
                                                              Icon(Icons.remove_circle_outline, color: styles.classicFont),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "${texts.habitsFrequency}: ${week_value.toInt()} ${texts.habitsConn} ${item.frequency}",
                                                    style: TextStyle(fontSize: 15, color: styles.classicFont),
                                                  ),
                                                  GestureDetector(
                                                      onTap: (){
                                                        var existingHabit = habitsTodos.getAt(indexListHabitsMirror[index]) as HabitTodos;
                                                        DateTime dtKey = existingHabit.efficiency.keys.last;
                                                        double dtValue = existingHabit.efficiency.values.last;
                                                        if(existingHabit.efficiency[dtKey]! < existingHabit.frequency){
                                                          existingHabit.efficiency[dtKey] = dtValue + 1;
                                                          setState(() {
                                                            habitsTodos.putAt(indexListHabitsMirror[index], existingHabit);
                                                            item.efficiency[dtKey] = dtValue + 1;
                                                          });
                                                        }
                                                      },
                                                      child: Icon(Icons.add, size: 25,
                                                        color: Color(item.dailyTheme))
                                                  )
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
                                        key: Key("2"),
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.decelerate,
                                        tween: Tween<double>(
                                          begin: 0,
                                          end: item.frequency.toDouble(),
                                        ),
                                        builder: (context,value, _) =>
                                            LinearProgressIndicator(
                                              // Tu określ procent postępu (0.6 oznacza 60%)
                                              value: (week_value/item.frequency.toDouble()),
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(item.dailyTheme)), // Tutaj możesz wybrać kolor
                                              backgroundColor: Colors.transparent, // Ustaw kolor tła na transparentny
                                              minHeight: 4, // Ustaw wysokość paska postępu (grubość)
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        item.fullTime < 9999 ? "${texts.habitsProgress}: ${item.dayNumber} "
                                            "${texts.habitsConn} ${item.fullTime} ${texts.habitsProgressDays}" :
                                        "${texts.habitsProgress}: ${item.dayNumber} ${item.dayNumber > 1 ? texts.daysString : texts.dayString}",
                                        style: TextStyle(fontSize: 15, color: styles.classicFont),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    if(item.fullTime < 9999)
                                      Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0), // Ustaw zaokrąglone rogi
                                        color: Colors.grey, // Kolor tła kontenera
                                      ),
                                      child: TweenAnimationBuilder<double>(
                                        key: Key("3"),
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.decelerate,
                                        tween: Tween<double>(
                                          begin: 0,
                                          end: item.fullTime.toDouble(),
                                        ),
                                        builder: (context,value, _) =>
                                            LinearProgressIndicator(
                                              // Tu określ procent postępu (0.6 oznacza 60%)
                                              value: (item.dayNumber/item.fullTime.toDouble()),
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(item.dailyTheme)), // Tutaj możesz wybrać kolor
                                              backgroundColor: Colors.transparent, // Ustaw kolor tła na transparentny
                                              minHeight: 4, // Ustaw wysokość paska postępu (grubość)
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (index < habitsTodos.length - 1) Divider(color: styles.mainBackgroundColor,), // Dodaj Divider, jeśli to nie jest ostatni element listy
                            ],
                          );
                        },
                      ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
