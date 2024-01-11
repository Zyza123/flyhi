import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flyhi/HiveClasses/DailyTodos.dart';
import 'package:flyhi/HiveClasses/HabitTodos.dart';
import 'package:flyhi/MenuPages/habit/addHabit.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../HiveClasses/Achievements.dart';
import '../../HiveClasses/HabitArchive.dart';
import '../../HiveClasses/Pets.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Notification/NotificationManager.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';
import 'dart:math';

import 'addDaily.dart';
import 'detailsHabit.dart';
import 'finishedHabits.dart';

enum SampleItem { edit, remove, postpone }
enum SampleItemHabit {edit, remove, minus, details }

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
  late Box pets;
  List<HabitTodos> habitsCopy = [];
  List<int> indexListHabitsMirror = [];

  late List<DateTime> weekDates = [];
  late List<int> fillweek = [];
  late int selectedDay;
  late int day_offset;
  late int reminder;
  //final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _menuHKey = GlobalKey();

  void openMenu() {
    dynamic state = _menuKey.currentState;
    state.showButtonMenu();
  }
  void openHMenu() {
    dynamic state = _menuHKey.currentState;
    state.showButtonMenu();
  }
  Future<void> getRemindFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reminder = prefs.getInt('REMINDER') ?? 0;
  }

  Future<void> getOffsetFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    day_offset = prefs.getInt('DAY_OFFSET') ?? 0;
  }

  void addNotificationsToNewDuties() async{
    List<PendingNotificationRequest> an = await NotificationManager().flutterLocalNotificationsPlugin.pendingNotificationRequests();

      if(an.isEmpty && dailyTodos.isNotEmpty){
        for(int i = 0; i < dailyTodos.length; i++){
          DailyTodos dt = dailyTodos.getAt(i);
          DateTime eventTime = DateTime(dt.date.year,dt.date.month,dt.date.day,int.parse(dt.time[0]),int.parse(dt.time[1]));
          TimeOfDay tod = TimeOfDay(hour: eventTime.hour, minute: eventTime.minute);
          if(eventTime.subtract(Duration(minutes: 30)).isAfter(DateTime.now())){
            NotificationManager().scheduleNotification(scheduledNotificationDateTime: eventTime.subtract(Duration(minutes: 30)),title: tod.toString(), body: '${dt.name}', id: dt.key);
          }
        }
      }
  }

  void fillData() {
    weekDates.clear();
    fillweek.clear();
    DateTime today = DateTime(DateTime.now().subtract(Duration(hours: day_offset)).year,
        DateTime.now().subtract(Duration(hours: day_offset)).month,
        DateTime.now().subtract(Duration(hours: day_offset)).day);
    for (int i = 0; i < 7; i++) {
      weekDates.add(today.add(Duration(days: i)));
      fillweek.add(weekDates[i].weekday - 1);
    }
    selectedDay = 0;
  }

  void addElementsToTodosAsc(int dayShift){
    todosCopy.clear();
    indexListMirror.clear();
    DateTime day1 = DateTime.now().subtract(Duration(hours: day_offset));
    int sel_day = dayShift == 0 ? day1.day: day1.add(Duration(days: dayShift)).day;
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < dailyTodos.length; j++){
        if(sel_day == dailyTodos.getAt(j).date.day){
          if(dailyTodos.getAt(j).importance == i)
          todosCopy.add(dailyTodos.getAt(j));
          // print("dzien: "+dailyTodos.getAt(i).date.day.toString());
          indexListMirror.add(j);
        }
      }
    }
  }

  void addElementsToTodosDesc(int dayShift){
    todosCopy.clear();
    indexListMirror.clear();
    DateTime day1 = DateTime.now().subtract(Duration(hours: day_offset));
    int sel_day = dayShift == 0 ? day1.day: day1.add(Duration(days: dayShift)).day;
    for(int i = 2; i >= 0; i--){
      for(int j = 0; j < dailyTodos.length; j++){
        if(sel_day == dailyTodos.getAt(j).date.day){
          if(dailyTodos.getAt(j).importance == i)
            todosCopy.add(dailyTodos.getAt(j));
          // print("dzien: "+dailyTodos.getAt(i).date.day.toString());
          indexListMirror.add(j);
        }
      }
    }
  }

  void addElementsToTodos(int dayShift){
    todosCopy.clear();
    indexListMirror.clear();
    DateTime day1 = DateTime.now().subtract(Duration(hours: day_offset));
    int sel_day = dayShift == 0 ? day1.day: day1.add(Duration(days: dayShift)).day;
    for(int i = 0; i < dailyTodos.length; i++){
      if(sel_day == dailyTodos.getAt(i).date.day){
        todosCopy.add(dailyTodos.getAt(i));
       // print("dzien: "+dailyTodos.getAt(i).date.day.toString());
        indexListMirror.add(i);
      }
    }
  }

  double timeToDouble(TimeOfDay time1){
    double time1double = time1.hour + time1.minute/60.0;
    return time1double;
  }

  void addElementsToTodosHourly(int dayShift) {
    todosCopy.clear();
    indexListMirror.clear();
    Map<int, double> mapa = {};
    DateTime day1 = DateTime.now().subtract(Duration(hours: day_offset));
    int sel_day = dayShift == 0 ? day1.day: day1.add(Duration(days: dayShift)).day;
    for (int i = 0; i < dailyTodos.length; i++)
    {
      if (sel_day == dailyTodos.getAt(i).date.day) {
        TimeOfDay time = TimeOfDay(hour: int.parse(dailyTodos.getAt(i).time[0]), minute: int.parse(dailyTodos.getAt(i).time[1]));
        mapa[i] = timeToDouble(time);
      }
    }
    var posortowanaMapa = Map.fromEntries(mapa.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value)));

    posortowanaMapa.forEach((key, value) {
      todosCopy.add(dailyTodos.getAt(key));
      indexListMirror.add(key);
    });
    mapa.clear();
    posortowanaMapa.clear();
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
      DateTime today = DateTime(DateTime.now().subtract(Duration(hours: day_offset)).year,
          DateTime.now().subtract(Duration(hours: day_offset)).month,
          DateTime.now().subtract(Duration(hours: day_offset)).day);
      if(today.isAfter(existingHabit.date) || today.isAtSameMomentAs(existingHabit.date)){
        DateTime before = existingHabit.efficiency.keys.last;
        DateTime week_before = today.subtract(Duration(days: 7));
        int days_dif = (today.difference(before).inHours/24).ceil() + 1;

        int habit_day_counter = (today.difference(existingHabit.date).inHours/24).ceil() + 1;
        if(existingHabit.dayNumber <= existingHabit.fullTime){
          existingHabit.dayNumber = habit_day_counter;
        }
        if(week_before.isAtSameMomentAs(before) || week_before.isAfter(before)){
          existingHabit.efficiency[today] = 0.0;
          int getExp = 8 + (existingHabit.efficiency.length * (1 + existingHabit.frequency.toDouble()/10)).toInt();
          Pets pet = pets.getAt(0);
          pet.addExp(getExp);
          pet.checkLvlUp();
          pets.putAt(0, pet);
        }
        habitsTodos.putAt(i, existingHabit);
        habitsCopy.add(habitsTodos.getAt(i));
        indexListHabitsMirror.add(i);
      }
    }
  }

  int calculateExpForHabit(HabitTodos ht){
    int frequencyAll = 0;
    ht.efficiency.forEach((key, value) {
      frequencyAll += value.toInt();
    });
    return frequencyAll * 3;
  }
  // remove all old habits and add them to archive
  void removeOldHabits(){
    List<dynamic> toRemove = [];
    for(int i = habitsTodos.length -1; i >= 0; i--)
    {
      var existingHabit = habitsTodos.getAt(i);
      DateTime today = DateTime(DateTime.now().subtract(Duration(hours: day_offset)).year,
          DateTime.now().subtract(Duration(hours: day_offset)).month,
          DateTime.now().subtract(Duration(hours: day_offset)).day);
      //print("nazwa: "+existingHabit.name.toString());
      //print("Dzisiaj: "+today.toString());
      //print("Wtedy: "+existingHabit.date.toString());
      //print("numer dnia: "+existingHabit.dayNumber.toString());
      //print("ilosc dni: "+existingHabit.fullTime.toString());
      if(today.isAfter(existingHabit.date) || today.isAtSameMomentAs(existingHabit.date)){
        if(existingHabit.dayNumber > existingHabit.fullTime){
          HabitTodos ht = habitsTodos.getAt(i);
          ht.dayNumber -= 1;
          habitsArchive.add(rewriteToArchive(ht));
          toRemove.add(habitsTodos.keyAt(i));
          Pets pet = pets.getAt(0);
          pet.addExp(calculateExpForHabit(ht));
          pet.checkLvlUp();
          pets.putAt(0, pet);
        }
      }
    }
    habitsTodos.deleteAll(toRemove);
    toRemove.clear();
  }

  HabitArchive rewriteToArchive(HabitTodos ht){
    return HabitArchive(ht.name, ht.icon, ht.date, ht.frequency, ht.fullTime, ht.dayNumber, ht.efficiency, ht.dailyTheme);
  }

  void addElementsToHabitsByNew(){
    // co jeszcze brakuje
    // dodanie usuwania starych nawyków które się już skończyły i dodanie ich danych całych do
    // klasy z osiągnięciami gdy już będzie stworzona
    habitsCopy.clear();
    indexListHabitsMirror.clear();
    for(int i = habitsTodos.length -1; i >= 0; i--)
    {
      HabitTodos existingHabit = habitsTodos.getAt(i);
      DateTime today = DateTime(DateTime.now().subtract(Duration(hours: day_offset)).year,
          DateTime.now().subtract(Duration(hours: day_offset)).month,
          DateTime.now().subtract(Duration(hours: day_offset)).day);
      if(today.isAfter(existingHabit.date) || today.isAtSameMomentAs(existingHabit.date)){
        DateTime before = existingHabit.efficiency.keys.last;
        DateTime week_before = today.subtract(Duration(days: 7));
        int days_dif = (today.difference(before).inHours/24).ceil() + 1;
        if(existingHabit.dayNumber <= existingHabit.fullTime){
          existingHabit.dayNumber = days_dif;
        }
        if(week_before.isAtSameMomentAs(before) || week_before.isAfter(before)){
          existingHabit.efficiency[today] = 0.0;
          //obliczanie expa dodawanego co tydzien
          int getExp = 8 + (existingHabit.efficiency.length * (1 + existingHabit.frequency.toDouble()/10)).toInt();
          Pets pet = pets.getAt(0);
          pet.addExp(getExp);
          pet.checkLvlUp();
          pets.putAt(0, pet);
        }
        habitsTodos.putAt(i, existingHabit);
        habitsCopy.add(habitsTodos.getAt(i));
        indexListHabitsMirror.add(i);
      }
    }
  }

  void removeOldTodos(){
    DateTime today = DateTime.now().subtract(Duration(hours: day_offset));
    List<dynamic> toRemove = [];
    int points_counter = 0;
    Pets pet = pets.getAt(0);
    for(int i = 0; i < dailyTodos.length; i++){
      DailyTodos todo = dailyTodos.getAt(i);
      bool different = (today.day != todo.date.day) && today.isAfter(todo.date);
      if(different){
        toRemove.add(dailyTodos.keyAt(i));
        if(dailyTodos.getAt(i).status == "done"){
          points_counter++;
          pet.addExp(10);
        }
      }
    }
    pet.checkLvlUp();
    pets.putAt(0, pet);
    // dodawanie do osiągnieć punktów ze zdobytych obowiazkow
    Achievements ach = achievements.getAt(2);
    ach.value += points_counter;
    while(ach.value >= ach.level[ach.progress]){
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

  Future<void> readTodoData(DateTime pickedDay) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "filter";
    if(prefs.containsKey("filter")){
      setState(() {
        selectedTodoFilter = prefs.getInt('filter')!;
        int days_diff = (pickedDay.difference(weekDates[0]).inHours/24).ceil();
        print("days diff: "+days_diff.toString());
        if(selectedTodoFilter == 0){
          addElementsToTodos(days_diff);
        }
        else if(selectedTodoFilter == 1){
          addElementsToTodosAsc(days_diff);
        }
        else if(selectedTodoFilter == 2){
          addElementsToTodosDesc(days_diff);
        }
        else{
          addElementsToTodosHourly(days_diff);
        }
        if(reminder == 1){
        addNotificationsToNewDuties();
        }
      });
    }
    else{
      // domyslnie bedzie wybrany ten
      await prefs.setInt('filter', 0);
      setState(() {
      selectedTodoFilter = prefs.getInt('filter')!;
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
    else{
      saveHabitFilter(0);
    }
  }

  @override
  void initState() {
    super.initState();
    achievements = Hive.box('achievements');
    dailyTodos = Hive.box('daily');
    pets = Hive.box('pets');
    getRemindFromPrefs();
    getOffsetFromPrefs().then((value) {
      fillData();
      if(dailyTodos.isNotEmpty){
        //dailyTodos.add(DailyTodos("test", 'assets/images/ikona4/128x128.png', "not done", DateTime.now().subtract(Duration(days: 1)),[DateTime.now().hour.toString(),DateTime.now().minute.toString()],0, 0xFFD0312D));
        removeOldTodos();
      }
      DateTime pickedDateFormat = DateTime(DateTime.now().subtract(Duration(hours: day_offset)).year,
          DateTime.now().subtract(Duration(hours: day_offset)).month,
          DateTime.now().subtract(Duration(hours: day_offset)).day);
      readTodoData(pickedDateFormat);
      habitsTodos = Hive.box('habits');
      habitsArchive = Hive.box('habitsArchive');
     //habitsTodos.add(HabitTodos("Testowy2", 'assets/images/ikona${3 + 1}/128x128.png',
     //    pickedDateFormat.subtract(Duration(days: 7)), 3, 7, 8,
     //    {pickedDateFormat : 3}, 0xFFD0312D));
      if(habitsTodos.isNotEmpty){
        removeOldHabits();
      }
      readHabitData();
    });
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
        padding: const EdgeInsets.only(top: 25),
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  children: [
                    Text(texts.todosMain,style: TextStyle(
                        fontSize: 30,fontWeight: FontWeight.bold,color: styles.classicFont),),
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
                    SizedBox(height: 15,),
                    todo_mode == 0? Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(weekDates.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                //print('Wybrano dzień: ${weekDates[index]}');
                                setState(() {
                                  selectedDay = index;
                                  readTodoData(weekDates[selectedDay]);
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
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
                    ): Container(),
                    SizedBox(height: 10,),
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
                                MaterialPageRoute(builder: (context) => AddDaily(editMode: false, editIndex: -1, dayShift: selectedDay,
                                  longerDay: DateTime.now().day != weekDates[0].day ? true : false, reminder: reminder == 0? false: true)
                                )).then((value){
                                  if(value == true) {
                                      setState(() {
                                        readTodoData(weekDates[selectedDay]);
                                      });
                                    }
                              })
                              :
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddHabit(editMode: false, editIndex: -1,
                                    longerDay: DateTime.now().day != weekDates[0].day ? true : false,))
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
                                readTodoData(weekDates[selectedDay]);
                              }
                              else if(newValue == texts.todosFilterList[1]){
                                saveTodoFilter(1);
                                selectedTodoFilter = 1;
                                readTodoData(weekDates[selectedDay]);
                              }
                              else if(newValue == texts.todosFilterList[2]){
                                saveTodoFilter(2);
                                selectedTodoFilter = 2;
                                readTodoData(weekDates[selectedDay]);
                              }
                              else if(newValue == texts.todosFilterList[3]){
                                saveTodoFilter(3);
                                selectedTodoFilter = 3;
                                readTodoData(weekDates[selectedDay]);
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FinishedHabits()),
                              );
                            },
                            child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: styles.elementsInBg,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Icon(Icons.done_all, color: styles.classicFont)
                            ),
                          ),

                        ],
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
                        return GestureDetector(
                          onLongPress: (){
                            openMenu();
                          },
                          child: Column(
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
                                          fit: BoxFit.scaleDown,
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
                                                    key: _menuKey,
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
                                                            MaterialPageRoute(builder: (context) => AddDaily(editMode: true, editIndex: indexListMirror[index],dayShift: selectedDay,
                                                              longerDay: DateTime.now().day != weekDates[0].day ? true : false,reminder: reminder == 0? false: true)
                                                            )).then((value){
                                                          if(value == true) {
                                                            setState(() {
                                                              dailyTodos = Hive.box('daily');
                                                              readTodoData(weekDates[selectedDay]);
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
                                                                      NotificationManager().flutterLocalNotificationsPlugin.cancel(indexListMirror[index]);
                                                                      readTodoData(weekDates[selectedDay]);
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
                                                          readTodoData(weekDates[selectedDay]);
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
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${int.parse(item.time[0]) > 9 ? int.parse(item.time[0]) : ('0'+item.time[0])}:'
                                                            '${int.parse(item.time[1]) > 9 ? int.parse(item.time[1]) : ('0'+item.time[1])}',
                                                        style: TextStyle(fontSize: 15, color: styles.classicFont, fontWeight: FontWeight.bold),
                                                      ),
                                                      SizedBox(width: 15,),
                                                      Text(
                                                        "${texts.addDailyImportance.toLowerCase()}: ${texts.addDailyImpList[item.importance]}",
                                                        style: TextStyle(fontSize: 15, color: styles.classicFont),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    key: Key("123456"),
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20.0),
                                        child: TweenAnimationBuilder<double>(
                                        key: Key("1"+weekDates[selectedDay].day.toString()),  // osobne klucze dla danego okna tweenów
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
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (index < dailyTodos.length - 1) Divider(color: styles.mainBackgroundColor,), // Dodaj Divider, jeśli to nie jest ostatni element listy
                            ],
                          ),
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
                            return GestureDetector(
                              onLongPress: (){
                                openHMenu();
                              },
                              child: Column(
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
                                              fit: BoxFit.scaleDown,
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
                                                        key: _menuHKey,
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
                                                                MaterialPageRoute(builder: (context) => AddHabit(editMode: true, editIndex: indexListHabitsMirror[index],
                                                                  longerDay: DateTime.now().day != weekDates[0].day ? true : false,)
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
                                                          if(item1.index == 3){
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => DetailsHabit(editIndex: indexListHabitsMirror[index], habitType: 0,)
                                                                ));
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
                                                          PopupMenuItem<SampleItemHabit>(
                                                            value: SampleItemHabit.details,
                                                            child: Container(
                                                              height: 40,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text("details", style: TextStyle(color: styles.classicFont)),
                                                                  Icon(Icons.read_more, color: styles.classicFont),
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
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20.0),
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
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20.0),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index < habitsTodos.length - 1) Divider(color: styles.mainBackgroundColor,), // Dodaj Divider, jeśli to nie jest ostatni element listy
                                ],
                              ),
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
      ),
    );
  }
}
