import 'package:flutter/material.dart';
import 'package:flyhi/HiveClasses/HabitArchive.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';
import 'detailsHabit.dart';

class FinishedHabits extends StatefulWidget {
  const FinishedHabits({super.key});

  @override
  State<FinishedHabits> createState() => _FinishedHabitsState();
}

class _FinishedHabitsState extends State<FinishedHabits> {
  late Box habitArchive;

  @override
  void initState() {
    habitArchive = Hive.box('habitsArchive');
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: styles.classicFont),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: styles.elementsInBg,
        title: Text(
          texts.finishedHabitsName,
          style: TextStyle(color: styles.classicFont, fontSize: 16),
        ),
      ),
      body: habitArchive.isEmpty
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty,color: styles.fontMenuOff,
                size: 35,),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  "No finished habits to show",
                  style: TextStyle(
                    color: styles.fontMenuOff,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          )
          : SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: habitArchive.length,
              itemBuilder: (BuildContext context, int index) {
                final item = habitArchive.getAt(index) as HabitArchive;
                return Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: styles.elementsInBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            item.icon,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                color: styles.classicFont,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => DetailsHabit(editIndex: index, habitType: 1,)
                                        ));
                                  },
                                  child: Icon(
                                    Icons.read_more_outlined, size: 27, color: styles.classicFont,
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${texts.habitsProgress}: ${item.dayNumber} "
                              "${texts.habitsConn} ${item.fullTime} ${texts.habitsProgressDays}",
                          style: TextStyle(fontSize: 15, color: styles.classicFont),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}
