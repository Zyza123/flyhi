import 'package:flutter/material.dart';
import 'package:flyhi/HiveClasses/HabitArchive.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../HiveClasses/HabitTodos.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class DetailsHabit extends StatefulWidget {
  const DetailsHabit({super.key,required this.editIndex, required this.habitType});
  final int editIndex;
  final int habitType;

  @override
  State<DetailsHabit> createState() => _DetailsHabitState();
}

class _DetailsHabitState extends State<DetailsHabit> {

  late Box dailyHabits;
  List<ChartData> chartData = [];
  late TooltipBehavior _tooltipBehavior;
  late var habit;

  void getHiveFromIndex(){
      habit = dailyHabits.getAt(widget.editIndex);
  }

  String formatChartData(DateTime dt){
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  void getEfficiencyMap(){
    chartData.clear();
    var habit = dailyHabits.getAt(widget.editIndex);
    DateTime firstDate = habit.efficiency.keys.first;
    firstDate = firstDate.subtract(Duration(days: 7));
    String formatted = formatChartData(firstDate);
    chartData.add(ChartData(formatted, 0));
    habit.efficiency.forEach((DateTime key, double value) {
      // Utworzenie formatu daty z tylko rokiem, miesiącem i dniem
      String formattedDate = formatChartData(key);

      // Dodanie danych do chartData (przy założeniu, że ChartData przyjmuje string jako pierwszy argument)
      chartData.add(ChartData(formattedDate, value));
    });
  }

  @override
  void initState() {
    super.initState();
    dailyHabits = widget.habitType == 0 ? Hive.box('habits') : Hive.box('habitsArchive');
    getHiveFromIndex();
    getEfficiencyMap();
    _tooltipBehavior = TooltipBehavior(enable: true);
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
            onPressed: (){Navigator.pop(context);}
        ),
        backgroundColor: styles.elementsInBg,
        title:
            Text(
              texts.detailsHabitName,
              style: TextStyle(color: styles.classicFont,fontSize: 16),
            ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0,bottom: 5),
            child: Column(
              children: [
                Container(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelRotation: chartData.length > 5 ? 90 : 0, // Obraca etykiety osi X
                      labelStyle: TextStyle(color: styles.classicFont),
                      //labelFormat: '{value:MM/dd}', // Formatuje datę
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0, // Minimalna wartość osi Y
                      maximum: 8, // Maksymalna wartość osi Y
                      interval: 1,
                      labelStyle: TextStyle(color: styles.classicFont),
                    ),
                    title: ChartTitle(text: habit.name,textStyle: TextStyle(fontSize: 18,color: styles.classicFont)),
                    legend: Legend(
                        isVisible: true,
                        position: LegendPosition.top, // Umieszcza legendę na górze
                        textStyle: TextStyle(color: styles.classicFont)
                    ),
                    tooltipBehavior: _tooltipBehavior,
                    series: <LineSeries<ChartData, String>>[
                      LineSeries<ChartData,String>(
                          name: texts.habitsFrequency,
                          dataSource: chartData,
                          xValueMapper: (ChartData chd, _) => chd.week,
                          yValueMapper: (ChartData chd, _) => chd.frequency,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          animationDuration: 1000,)
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        texts.addHabitDateOfAppearance,textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18, color: styles.classicFont),)
                  ),
                ),
                SizedBox(height: 5,),
                FittedBox(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: styles.elementsInBg,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      "${habit.date}".split(' ')[0],
                      style: TextStyle(fontSize: 16, color: styles.classicFont),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                      child: Text(
                        texts.habitsProgress ,textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18, color: styles.classicFont),)
                  ),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TweenAnimationBuilder<double>(
                    key: Key("12222"),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.decelerate,
                    tween: Tween<double>(
                      begin: 0,
                      end: (habit.dayNumber / habit.fullTime.toDouble()),
                    ),
                    builder: (context, value, _) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${habit.dayNumber}   ',
                              style: TextStyle(color: Color(0xFF508bba),
                                fontSize: 16,fontWeight: FontWeight.bold,),
                            ),
                            if(habit.fullTime.toDouble() < 9999)
                              Text(
                                '/   ',
                                style: TextStyle(color: Color(0xFF508bba),
                                    fontSize: 16,fontWeight: FontWeight.bold),
                              ),
                            if(habit.fullTime.toDouble() < 9999)
                              Text(
                                '${habit.fullTime} ',
                                style: TextStyle(color: Color(0xFF508bba),
                                    fontSize: 16,fontWeight: FontWeight.bold),
                              ),
                            Text(
                              '${texts.habitsProgressDays}',
                              style: TextStyle(color: Color(0xFF508bba),
                                  fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        if(habit.fullTime.toDouble() < 9999)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: value,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF508bba)),
                              backgroundColor: styles.todosPickerOn,
                              minHeight: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.week, this.frequency);
  final String week;
  final double frequency;
}
