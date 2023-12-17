import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../HiveClasses/HabitTodos.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class DetailsHabit extends StatefulWidget {
  const DetailsHabit({super.key,required this.editIndex});
  final int editIndex;

  @override
  State<DetailsHabit> createState() => _DetailsHabitState();
}

class _DetailsHabitState extends State<DetailsHabit> {

  late Box dailyHabits;
  List<ChartData> chartData = [];
  late TooltipBehavior _tooltipBehavior;
  late HabitTodos ht;

  void getHiveFromIndex(){
    ht = dailyHabits.getAt(widget.editIndex);
  }

  String formatChartData(DateTime dt){
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  void getEfficiencyMap(){
    chartData.clear();
    HabitTodos ht = dailyHabits.getAt(widget.editIndex);
    DateTime firstDate = ht.efficiency.keys.first;
    firstDate = firstDate.subtract(Duration(days: 7));
    String formatted = formatChartData(firstDate);
    chartData.add(ChartData(formatted, 0));
    ht.efficiency.forEach((DateTime key, double value) {
      // Utworzenie formatu daty z tylko rokiem, miesiącem i dniem
      String formattedDate = formatChartData(key);

      // Dodanie danych do chartData (przy założeniu, że ChartData przyjmuje string jako pierwszy argument)
      chartData.add(ChartData(formattedDate, value));
    });
  }

  @override
  void initState() {
    super.initState();
    dailyHabits = Hive.box('habits');
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
              "Habit Details",
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
                      //labelFormat: '{value:MM/dd}', // Formatuje datę
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0, // Minimalna wartość osi Y
                      maximum: 8, // Maksymalna wartość osi Y
                      interval: 1
                      // Możesz również ustawić interval, jeśli chcesz
                    ),
                    title: ChartTitle(text: ht.name,textStyle: TextStyle(fontSize: 18)),
                    legend: Legend(
                        isVisible: true,
                        position: LegendPosition.top // Umieszcza legendę na górze
                    ),
                    tooltipBehavior: _tooltipBehavior,
                    series: <LineSeries<ChartData, String>>[
                      LineSeries<ChartData,String>(
                          name: 'frequency',
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
                        "Start day:",textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18),)
                  ),
                ),
                FittedBox(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: styles.elementsInBg,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      "${ht.date}".split(' ')[0],
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
                        "Postęp:",textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18),)
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
                      end: (ht.dayNumber / ht.fullTime.toDouble()),
                    ),
                    builder: (context, value, _) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${ht.dayNumber}',
                              style: TextStyle(color: Color(0xFF508bba),
                                fontSize: 16,fontWeight: FontWeight.bold,),
                            ),
                            Text(
                              '   /   ',
                              style: TextStyle(color: Color(0xFF508bba),
                                  fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${ht.fullTime} DAYS',
                              style: TextStyle(color: Color(0xFF508bba),
                                  fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: value,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF508bba)),
                            backgroundColor: styles.todosPickerOn,
                            minHeight: 16,
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
