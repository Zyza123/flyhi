import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../HiveClasses/HabitTodos.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({super.key,required this.editMode, required this.editIndex});
  final bool editMode;
  final int editIndex;

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {

  late Box dailyHabits;
  DateTime _pickedDate = DateTime.now();
  bool enabledDateButton = true;
  bool enabledDaysButton = true;
  String _lengthValue = "Dni";
  bool do_once = true;
  int _iconValue = 0;
  int frequency_value = 1;
  double days_counter = 7;
  double minimum_days = 7;
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
  late Image mainHabitImage;

  void addHabit(){
    HabitTodos ht;
    DateTime pickedDateFormat = DateTime(_pickedDate.year,_pickedDate.month, _pickedDate.day);
    if(_lengthValue == "Nieokreślony" || _lengthValue == "Undefined"){
      days_counter = 9999;
    }
    ht = HabitTodos(tec.text, 'assets/images/ikona${_iconValue + 1}/128x128.png',
        pickedDateFormat, frequency_value, days_counter.toInt(), 1,
        {pickedDateFormat : 0}, selectedColor);
    dailyHabits.add(ht);
  }

  Future<void> _selectDate(BuildContext context, bool mode) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate,
      firstDate: DateTime.now(), // Ustala, że nie można wybrać daty wcześniejszej niż dzisiaj
      lastDate: DateTime.now().add(Duration(days: 30)), // Ustal maksymalną dostępną datę
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
      });
    }
  }

  void getHiveFromIndex(){
    tec.text = dailyHabits.getAt(widget.editIndex).name;
    _pickedDate= dailyHabits.getAt(widget.editIndex).date;
    enabledDateButton = false;
    frequency_value = dailyHabits.getAt(widget.editIndex).frequency;
    if(dailyHabits.getAt(widget.editIndex).fullTime < 9999){
      minimum_days = (dailyHabits.getAt(widget.editIndex).dayNumber + 1).toDouble();
      if(minimum_days < 7){
        minimum_days = 7;
      }
      days_counter = dailyHabits.getAt(widget.editIndex).fullTime.toDouble();
    }
    else{
      enabledDaysButton = false;
    }
    String modified = dailyHabits.getAt(widget.editIndex).icon;
    modified = modified.substring(0,modified.length - 11);
    modified += '32x32.png';
    _iconValue = customImagePaths.indexOf(modified);
    selectedColor = dailyHabits.getAt(widget.editIndex).dailyTheme;
  }

  void modifyHabit(){
    //var existingTodo = dailyTodos.getAt(widget.editIndex) as DailyTodos;
    //existingTodo.name = tec.text;
    //existingTodo.importance = getWeightValue();
    //existingTodo.icon = 'assets/images/ikona${_iconValue + 1}/128x128.png';
    //existingTodo.dailyTheme = selectedColor;
    //if(_dayValue == "Jutro" || _dayValue == "Tomorrow"){
    //  existingTodo.date = existingTodo.date.add(Duration(days: 1));
    //}
    //dailyTodos.putAt(widget.editIndex, existingTodo);
  }

  @override
  void didChangeDependencies() {
    precacheImage(mainHabitImage.image, context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    mainHabitImage = Image.asset('assets/images/addHabit.png',fit: BoxFit.fitHeight,);
    dailyHabits = Hive.box('habits');
    if(widget.editMode == true){
      getHiveFromIndex();
    }
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
    if(do_once){
      if(widget.editMode == true){
        if(dailyHabits.getAt(widget.editIndex).fullTime < 9999){
          _lengthValue = texts.addHabitDays;
        }
        else{
          _lengthValue = texts.addHabitUndefined;
        }
      }
      else{
        _lengthValue = texts.addHabitDays;
      }
      do_once = false;
    }
    return Scaffold(
      backgroundColor: styles.mainBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: styles.classicFont),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){Navigator.pop(context);}
        ),
        backgroundColor: styles.elementsInBg,
        title: Row(
          children: [
            Text(
              widget.editMode == false ? texts.addHabitAppBar : texts.modifyHabitAppBar,
              style: TextStyle(color: styles.classicFont,fontSize: 16),
            ),
            Spacer(), // Dodaj przerwę, aby przesunąć "Zapisz" na prawą stronę
            GestureDetector(
              onTap: () async {
                if(tec.text != ""){
                  if(widget.editMode){
                    setState(() {
                      modifyHabit();
                    });
                  }
                  else{
                    setState(() {
                      addHabit();
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
                  Text(texts.addSave, style: TextStyle(color: styles.classicFont,fontSize: 16)),
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
                child: mainHabitImage,
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
                          texts.addHabitName, // Lub 'Name' w zależności od języka
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
                          alignment: Alignment.topLeft,child: Text(texts.addThingWrongName,style: TextStyle(color: Colors.red,fontSize: 14),)) : Container(),
                      SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.addHabitDateOfAppearance, // Lub 'Name' w zależności od języka
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
                                "${_pickedDate.toLocal()}".split(' ')[0],
                                style: TextStyle(fontSize: 16, color: styles.classicFont),
                              ),
                            ),
                            Opacity(
                              opacity: enabledDateButton == true ? 1.0 : 0.5,
                              child: ElevatedButton(
                                onPressed: enabledDateButton == true?  () => _selectDate(context,themeChange.darkTheme) : null,
                                child: Text(texts.addHabitPickDate,style: TextStyle(color: styles.classicFont,fontSize: 16,
                                    fontWeight: FontWeight.w400),),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(styles.elementsInBg),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.addHabitFrequency, // Lub 'Name' w zależności od języka
                          style: TextStyle(fontSize: 16, color: styles.classicFont),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 40,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(styles.elementsInBg),
                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                              ),
                              onPressed: () {
                                if(frequency_value > 1){
                                  setState(() {
                                    frequency_value -= 1;
                                  });
                                }
                              },
                              child: Text(
                                '-',
                                style: TextStyle(color: styles.classicFont,fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: styles.elementsInBg,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              frequency_value.toString(),
                              style: TextStyle(color: styles.classicFont,fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            height: 40,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(styles.elementsInBg),
                              ),
                              onPressed: () {
                                if(frequency_value < 7){
                                  setState(() {
                                    frequency_value += 1;
                                  });
                                }
                              },
                              child: Text(
                                '+',
                                style: TextStyle(color: styles.classicFont,fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text(texts.addHabitFrequencyWeek, style: TextStyle(fontSize: 14,
                          color: styles.classicFont)),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Tooltip(
                          message: texts.addHabitWarning,
                          showDuration: Duration(seconds: 3),
                          triggerMode: TooltipTriggerMode.tap,
                          child: Row(
                            children: [
                              Text(
                                "${texts.addHabitLength} ", // Lub 'Name' w zależności od języka
                                style: TextStyle(fontSize: 16, color: styles.classicFont),
                              ),
                              Icon(
                                Icons.info_outline, // Ikona informacji
                                color: styles.classicFont, // Kolor ikony
                                size: 12, // Rozmiar ikony
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Opacity(
                              opacity: enabledDateButton == true ? 1.0 : 0.5,
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: texts.addHabitDays,
                                    groupValue: _lengthValue, // Ustaw stan wyboru
                                    onChanged: enabledDateButton == true ? (value) {
                                      setState(() {
                                        _lengthValue = value!;
                                      });
                                    } : null,
                                    activeColor: styles.classicFont,
                                    fillColor: MaterialStateColor.resolveWith((states) => styles.classicFont),
                                  ),
                                  Text(texts.addHabitDays, style: TextStyle(fontSize: 14,
                                      color: styles.classicFont)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: texts.addHabitUndefined,
                                  groupValue: _lengthValue, // Ustaw stan wyboru
                                  onChanged: (value) {
                                    setState(() {
                                      _lengthValue = value!;
                                    });
                                  },
                                  activeColor: styles.classicFont,
                                  fillColor: MaterialStateColor.resolveWith((states) => styles.classicFont),
                                ),
                                Text(texts.addHabitUndefined, style: TextStyle(fontSize: 14,
                                    color: styles.classicFont)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if(_lengthValue == texts.addHabitDays)
                        SizedBox(height: 5,),
                      if (_lengthValue == texts.addHabitDays)
                        Container(
                          width: 80,
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: styles.elementsInBg,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            days_counter.toInt().toString(),
                            style: TextStyle(color: styles.classicFont,fontSize: 18),
                          ),
                        ),
                      if (_lengthValue == texts.addHabitDays)
                        Slider(
                          activeColor: styles.sliderColorsAct,
                          inactiveColor: styles.sliderColorsInact,
                          value: days_counter,
                          onChanged: (double value) {
                            setState(() {
                              days_counter = value;
                              days_counter.floor();
                            });
                          },
                          min: minimum_days,
                          max: 365,
                        ),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          texts.addHabitIcon, // Lub 'Name' w zależności od języka
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
                          texts.addHabitTheme, // Lub 'Name' w zależności od języka
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
