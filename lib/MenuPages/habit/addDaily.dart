import 'package:flutter/material.dart';
import 'package:flyhi/HiveClasses/DailyTodos.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Notification/NotificationManager.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class AddDaily extends StatefulWidget {
  const AddDaily({super.key, required this.editMode, required this.editIndex, required this.dayShift,
    required  this.longerDay, required this.reminder});

  final bool editMode;
  final int editIndex;
  final int dayShift;
  final bool longerDay;
  final bool reminder;

  @override
  State<AddDaily> createState() => _AddDailyState();
}


class _AddDailyState extends State<AddDaily> {

  late Box dailyTodos;
  String _weightValue = "wysoka";
  late DateTime _pickedDate;
  int imp = 0;
  bool do_once = true;
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
  int selectedColor = 0xFFD0312D;
  TextEditingController tec = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool showValidationMessage = false;
  String mainDailyImage = 'assets/images/addTodo.png';
  late int day_offset;

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context, bool mode, String langmode) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
        builder: (BuildContext? context, Widget? child){
          return Theme(
            data: mode == false ? ThemeData.light() : ThemeData.dark(),
            child: Builder(
              builder: (BuildContext context) {
                return Localizations.override(
                  context: context,
                  locale: langmode == "ENG" ?  const Locale('en'): const Locale('pl'),
                  child: Builder(
                      builder: (BuildContext context){
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      }
                  ),
                );
              },
            ),
          );
        }
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void getHiveFromIndex(){
    tec.text = dailyTodos.getAt(widget.editIndex).name;
    String modified = dailyTodos.getAt(widget.editIndex).icon;
    modified = modified.substring(0,modified.length - 11);
    modified += '32x32.png';
    _pickedDate= dailyTodos.getAt(widget.editIndex).date;
    _selectedTime = TimeOfDay(hour: int.parse(dailyTodos.getAt(widget.editIndex).time[0]),
        minute: int.parse(dailyTodos.getAt(widget.editIndex).time[1]));
    _iconValue = customImagePaths.indexOf(modified);
    selectedColor = dailyTodos.getAt(widget.editIndex).dailyTheme;
    imp = dailyTodos.getAt(widget.editIndex).importance;
  }

  int getWeightValue(){
    if (_weightValue == 'wysoka' || _weightValue == 'high') {
      return 0;}
    else if (_weightValue == 'średnia' || _weightValue == 'medium') {
      return 1;}
    else if (_weightValue == 'niska' || _weightValue == 'low') {
      return 2;}
    return 0;
  }

  Future<void> _selectDate(BuildContext context, bool mode, String langmode) async {
    DateTime first = widget.longerDay ? DateTime.now().subtract(Duration(days: 1)): DateTime.now();
    print("first: "+widget.dayShift.toString());
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _pickedDate,
        locale: langmode == "ENG" ?  const Locale('en'): const Locale('pl'),
        firstDate: first, // Ustala, że nie można wybrać daty wcześniejszej niż dzisiaj
        lastDate: first.add(Duration(days: 6)), // Ustal maksymalną dostępną datę
        builder: (BuildContext? context, Widget? child){
          return Theme(
            data: mode == false ? ThemeData.light() : ThemeData.dark(),
            child: child!,
          );
        }
    );
    if (picked != null && picked != _pickedDate) {
      setState(() {
        _pickedDate = picked;
        if(_pickedDate.isAfter(DateTime.now())){
          _selectedTime = TimeOfDay(hour: 7, minute: 0);
        }
        else{
          _selectedTime = TimeOfDay.now();
        }
      });
    }
  }

  void addDuty(){
    int weightValue = getWeightValue();
    DailyTodos dt;
    dt = DailyTodos(tec.text, 'assets/images/ikona${_iconValue + 1}/128x128.png', "not done", _pickedDate,[_selectedTime.hour.toString(),_selectedTime.minute.toString()],weightValue, selectedColor);
    dailyTodos.add(dt);
    DateTime eventTime = DateTime(_pickedDate.year,_pickedDate.month,_pickedDate.day,_selectedTime.hour,_selectedTime.minute);
    TimeOfDay tod = TimeOfDay(hour: eventTime.hour, minute: eventTime.minute);
    if(eventTime.subtract(Duration(minutes: 30)).isAfter(DateTime.now()) && widget.reminder){
    NotificationManager().scheduleNotification(scheduledNotificationDateTime: eventTime.subtract(Duration(minutes: 30)),title: tod.toString(), body: '${tec.text}', id: dailyTodos.getAt(dailyTodos.length -1).key);
    }
    //NotificationManager().showNotification(title: eventTime.toString(), body: 'wydarzenie: ${tec.text}');
  }

  void modifyDuty(){
    var existingTodo = dailyTodos.getAt(widget.editIndex) as DailyTodos;
    existingTodo.name = tec.text;
    existingTodo.importance = getWeightValue();
    existingTodo.icon = 'assets/images/ikona${_iconValue + 1}/128x128.png';
    existingTodo.dailyTheme = selectedColor;
    existingTodo.date = _pickedDate;
    existingTodo.time = [_selectedTime.hour.toString(),_selectedTime.minute.toString()];
    DateTime eventTime = DateTime(_pickedDate.year,_pickedDate.month,_pickedDate.day,_selectedTime.hour,_selectedTime.minute);
    TimeOfDay tod = TimeOfDay(hour: eventTime.hour, minute: eventTime.minute);
    if(widget.reminder){
      NotificationManager().flutterLocalNotificationsPlugin.cancel(widget.editIndex);
      if(eventTime.subtract(Duration(minutes: 30)).isAfter(DateTime.now())){
        NotificationManager().scheduleNotification(scheduledNotificationDateTime: eventTime.subtract(Duration(minutes: 30)),title: tod.toString(), body: '${tec.text}', id: dailyTodos.getAt(widget.editIndex).key);
      }
    }
    dailyTodos.putAt(widget.editIndex, existingTodo);
  }

  @override
  void initState() {
    super.initState();
    dailyTodos = Hive.box('daily');
    if(widget.editMode == true){
      getHiveFromIndex();
    }
    else{
      DateTime today = DateTime.now();
      if(widget.longerDay){
        _pickedDate = today.add(Duration(days: widget.dayShift -1));
      }
      else{
        _pickedDate = today.add(Duration(days: widget.dayShift));
      }
      if(_pickedDate.day != DateTime.now().day){
        _selectedTime = TimeOfDay(hour: 7, minute: 0);
        print("tu 1");
      }
      else{
        _selectedTime = TimeOfDay.now();
        print("tu 2");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    final langChange = Provider.of<LanguageProvider>(context);
    Texts texts = Texts(language: langChange.language);
    if(do_once){
      _weightValue = texts.texts.addDailyImpList[imp];
      do_once = false;
    }
    return Scaffold(
      backgroundColor: styles.mainBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: styles.classicFont),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){Navigator.pop(context,false);}
        ),
        backgroundColor: styles.elementsInBg,
        title: Row(
          children: [
            Text(
              widget.editMode == false ? texts.texts.addDailyAppBar : texts.texts.modifyDailyAppBar,
              style: TextStyle(color: styles.classicFont,fontSize: 16),
            ),
            Spacer(), // Dodaj przerwę, aby przesunąć "Zapisz" na prawą stronę
            GestureDetector(
              onTap: () {
                if(tec.text != ""){
                  if(widget.editMode){
                    setState(() {
                      modifyDuty();
                    });
                  }
                  else{
                    setState(() {
                      addDuty();
                    });
                  }
                  Navigator.pop(context,true);
                }
                else {
                  setState(() {
                    showValidationMessage = true;
                  });
                }
              },
              child: Row(
                children: [
                  Text(texts.texts.addSave, style: TextStyle(color: styles.classicFont,fontSize: 16)),
                  Icon(Icons.check, color: styles.classicFont,size: 18,),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                child: FadeInImage(
                  fadeInDuration: Duration(milliseconds: 150),
                  key: ValueKey<String>(mainDailyImage), // Klucz jako ciąg znaków
                  placeholder: AssetImage('assets/empty.png'),
                  image: AssetImage(mainDailyImage), // Ścieżka do obrazu jako ciąg znaków
                  fit: BoxFit.fitHeight,
                )
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
                          texts.texts.addDailyName, // Lub 'Name' w zależności od języka
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
                            onChanged: (text) {
                              setState(() {
                                showValidationMessage = false;
                              });
                            },
                            style: TextStyle(color: styles.classicFont,
                            letterSpacing: 1.5),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                            ),
                            textAlignVertical: TextAlignVertical.top, // Wyśrodkowanie tekstu tylko w pionie
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      showValidationMessage == true ?Align(
                          alignment: Alignment.topLeft,child: Text(texts.texts.addThingWrongName,style: TextStyle(color: Colors.red,fontSize: 14),)) : Container(),
                      SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.texts.addDailyImportance, // Lub 'Name' w zależności od języka
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
                                  value: texts.texts.addDailyImpList[0],
                                  groupValue: _weightValue, // Ustaw stan wyboru
                                  onChanged: (value) {
                                    setState(() {
                                      _weightValue = value!;
                                    });
                                  },
                                  activeColor: styles.classicFont,
                                  fillColor: MaterialStateColor.resolveWith((states) => styles.classicFont),
                                ),
                                Text(texts.texts.addDailyImpList[0], style: TextStyle(fontSize: 14,
                                    color: styles.classicFont)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: texts.texts.addDailyImpList[1],
                                  groupValue: _weightValue, // Ustaw stan wyboru
                                  onChanged: (value) {
                                    setState(() {
                                      _weightValue = value!;
                                    });
                                  },
                                  activeColor: styles.classicFont,
                                  fillColor: MaterialStateColor.resolveWith((states) => styles.classicFont),
                                ),
                                Text(texts.texts.addDailyImpList[1], style: TextStyle(fontSize: 14,
                                    color: styles.classicFont)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: texts.texts.addDailyImpList[2],
                                  groupValue: _weightValue, // Ustaw stan wyboru
                                  onChanged: (value) {
                                    setState(() {
                                      _weightValue = value!;
                                    });
                                  },
                                  activeColor: styles.classicFont,
                                  fillColor: MaterialStateColor.resolveWith((states) => styles.classicFont),
                                ),
                                Text(texts.texts.addDailyImpList[2], style: TextStyle(fontSize: 14,
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
                          texts.texts.addDailyAppearDay, // Lub 'Name' w zależności od języka
                          style: TextStyle(fontSize: 16, color: styles.classicFont),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: styles.elementsInBg,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                _pickedDate != null
                                    ? "${_pickedDate!.toLocal()}".split(' ')[0]
                                    : 'Loading...',
                                style: TextStyle(fontSize: 16, color: styles.classicFont),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _selectDate(context, themeChange.darkTheme,
                                    langChange.language);
                              } ,
                              child: Text(texts.texts.addHabitPickDate,style: TextStyle(color: styles.classicFont,fontSize: 16,
                                  fontWeight: FontWeight.w400),),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(styles.elementsInBg),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.texts.addDailyHour, // Lub 'Name' w zależności od języka
                          style: TextStyle(fontSize: 16, color: styles.classicFont),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: styles.elementsInBg,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              '${_selectedTime.hour > 9 ? _selectedTime.hour : ('0'+_selectedTime.hour.toString())}:'
                                  '${_selectedTime.minute > 9 ? _selectedTime.minute : ('0'+_selectedTime.minute.toString())}',
                              style: TextStyle(fontSize: 16, color: styles.classicFont),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () => _selectTime(context,themeChange.darkTheme,langChange.language),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(styles.elementsInBg),
                            ),
                            child: Text(texts.texts.addDailyHourPickOther,style: TextStyle(color: styles.classicFont,fontSize: 16,
                                fontWeight: FontWeight.w400),),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.texts.addDailyIcon, // Lub 'Name' w zależności od języka
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
                                  child: Image.asset(customImagePaths[index],
                                  width: 64,height: 64,),
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
                          texts.texts.addDailyTheme, // Lub 'Name' w zależności od języka
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
                      SizedBox(height: 10,),
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
