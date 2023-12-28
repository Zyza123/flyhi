import 'package:flutter/material.dart';
import 'package:flyhi/HiveClasses/HabitTodos.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../HiveClasses/Achievements.dart';
import '../HiveClasses/HabitArchive.dart';
import '../HiveClasses/Pets.dart';
import '../Language/LanguageProvider.dart';
import '../Language/Texts.dart';
import '../Theme/DarkThemeProvider.dart';
import '../Theme/Styles.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {

  late Box achievements;
  late Box habits;
  late Box habitsArchive;
  late Box pets;
  List<String> mainImages = List.generate(5, (index) => 'assets/achievements/ach${index + 1}.png');

  void buildAchievements(){
    // dla 1 osiagniecia - wytrwały
    Achievements achievement1 = Achievements("0", mainImages[0], [7,21,70,210,365]);
    Achievements achievement2 = Achievements("1", mainImages[1], [2,5,10,20,40]);
    Achievements achievement3 = Achievements("2", mainImages[2], [10,25,75,150,300]);
    Achievements achievement4 = Achievements("3", mainImages[3], [70,80,90,95,100]);
    Achievements achievement5 = Achievements("4", mainImages[4], [10,20,30,40,50]);
    achievements.add(achievement1);
    achievements.add(achievement2);
    achievements.add(achievement3);
    achievements.add(achievement4);
    achievements.add(achievement5);
  }

  int checkHabitEffectiveness(int index){
    HabitArchive ht = habitsArchive.getAt(index);
    // czyli np dla 10 tygodni * 4 daje nam 40 cwiczen, w ostatnim tygodniu sprawdzamy ile bylo dni i dajemy srednia
    DateTime end = ht.efficiency.keys.first.add(Duration(days: ht.fullTime-1));
    int days_diff = (end.difference(ht.efficiency.keys.last).inHours/24).ceil();
    int weekCorrection = 0;
    if(ht.efficiency.keys.last != ht.efficiency.keys.first) {
      weekCorrection = ((days_diff / 7) * ht.frequency).toInt();
    }
    int full = ((ht.efficiency.length * ht.frequency) - weekCorrection);
    int collected = 0;
    ht.efficiency.forEach((key, value) {
      collected += value.toInt();
      index++;
    });
    print("effi: "+((1.0 * collected~/full) * 100).toInt().toString());
    print("coll: "+(collected.toString()));
    print("full: "+(full.toString()));
    return ((1.0 * collected~/full) * 100).toInt();
  }

  void readAchievements(){
    // odczyt danych do progressu
    // ach1 - pobiera z habits utrzymanie nawyku bez sprawdzania efektywnosci
    Achievements ach = achievements.getAt(0);
    for(int i = 0; i < habits.length; i++){
      HabitTodos ht = habits.getAt(i);
      while(ht.dayNumber >= ach.level[ach.progress]){
        ach.progress += 1;
        achievements.putAt(0, ach);
      }
    }
    // ach2 - pobiera juz z archiwum skończone nawyki i sprawdza ile maja efekt.
    // jesli > 49 to liczy je
    ach = achievements.getAt(1);
    ach.value = 0;
    for(int i = 0; i < habitsArchive.length; i++){
      HabitArchive ha = habitsArchive.getAt(i);
      if(checkHabitEffectiveness(i) > 49){
        ach.value++;
      }
    }
    print("archiwum : "+habitsArchive.length.toString());
    while(ach.value >= ach.level[ach.progress]){
      ach.progress += 1;
      achievements.putAt(1, ach);
    }

    // ach 3 - pomijam - liczy todosy w HabitPage podczas usuwania po każdym dniu
    // ach 4 - sprawdzanie najwiekszego effectiveness nawyku który ma min 30 dni
    ach = achievements.getAt(3);
    int index = -1;
    int effectiveness = 0;
    for(int i = 0; i < habitsArchive.length; i++){
      HabitArchive ha = habitsArchive.getAt(i);
      if(ha.dayNumber >= 30){
        int temp_effectiveness = checkHabitEffectiveness(i);
          if(index != -1){
            if(temp_effectiveness > effectiveness){
              index = i;
              effectiveness = temp_effectiveness;
            }
          }
          else{
            index = i;
            effectiveness = temp_effectiveness;
          }
      }
    }

    if(index != -1){
      ach.value = effectiveness;
      while(checkHabitEffectiveness(index) >= ach.level[ach.progress]){
        ach.progress += 1;
      }
      achievements.putAt(3,ach);
    }

    ach = achievements.getAt(4);
    Pets pet = pets.getAt(0);
    int highest_level = 0;
    for (var element in pet.level) {
      if(element > highest_level){
        highest_level = element;
      }
    }
    ach.value = highest_level;
    while(ach.value >= ach.level[ach.progress]){
      ach.progress += 1;
    }
    achievements.putAt(4,ach);
  }

  @override
  void initState() {
    super.initState();
    achievements = Hive.box('achievements');
    habits = Hive.box('habits');
    habitsArchive = Hive.box('habitsArchive');
    pets = Hive.box('pets');
    if(achievements.isEmpty){
      buildAchievements();
      readAchievements();
    }
    else{
      readAchievements();
    }


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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                texts.achievementsTitle,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: styles.classicFont,
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: achievements.length,
                  itemBuilder: (BuildContext context, int index) {
                    Achievements achievement = achievements.getAt(index) as Achievements;
                    // Tutaj możesz dostosować sposób wyświetlania poszczególnych osiągnięć
                    // Możesz użyć np. ListTile, Container, itp.
                    return Container(
                      width: 160,
                      height: 175,
                      margin: EdgeInsets.all(8.0), // Możesz dostosować marginesy według własnych preferencji
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: styles.achievementsColor
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(texts.achievementsTitleText[int.tryParse(achievement.name) ?? 0],
                                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: styles.classicFont),),
                                  SizedBox(height: 5.0),
                                  Text(texts.achievementsMainText[int.tryParse(achievement.name) ?? 0],
                                    style: TextStyle(fontSize: 14,color: styles.classicFont),),
                                  Spacer(),
                                  Text("${texts.habitsProgress}: ${achievement.value}"+(index == 3 ? "%" : "") + "/ ${achievement.level[achievement.progress]}"+
                                      (index == 3 ? "%" : ""),
                                    style: TextStyle(fontSize: 14,color: styles.classicFont,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: List.generate(
                                      5,
                                          (index) => Container(
                                        width: 10, // szerokość jednego koła
                                        height: 10, // wysokość jednego koła
                                        margin: EdgeInsets.only(right: index < 4 ? 10.0 : 0), // Dodaj margines tylko do kołek poza ostatnim
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: index < achievement.progress
                                              ? styles.classicFont // Kolor wypełnionego koła
                                              : Colors.grey, // Kolor pustego koła
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,)
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Image.asset(
                              achievement.image,
                              width: 125, // Możesz dostosować szerokość obrazu według własnych preferencji
                              height: 125, // Możesz dostosować wysokość obrazu według własnych preferencji
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
