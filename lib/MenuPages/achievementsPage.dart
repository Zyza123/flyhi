import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../HiveClasses/Achievements.dart';
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
  List<String> mainImages = List.generate(5, (index) => 'assets/achievements/ach${index + 1}.png');

  void buildAchievements(){
    // dla 1 osiagniecia - wytrwały
    Achievements achievement1 = Achievements("0", mainImages[0], [7,21,60,180,365]);
    Achievements achievement2 = Achievements("1", mainImages[1], [2,5,10,20,40]);
    Achievements achievement3 = Achievements("2", mainImages[2], [10,25,75,150,300]);
    Achievements achievement4 = Achievements("3", mainImages[3], [70,80,90,95,100]);
    Achievements achievement5 = Achievements("4", mainImages[4], [1,2,3,4,5]);
    achievements.add(achievement1);
    achievements.add(achievement2);
    achievements.add(achievement3);
    achievements.add(achievement4);
    achievements.add(achievement5);
  }


  @override
  void initState() {
    super.initState();
    achievements = Hive.box('achievements');
    if(achievements.isEmpty){
      buildAchievements();
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
                    print(achievement.image);
                    // Tutaj możesz dostosować sposób wyświetlania poszczególnych osiągnięć
                    // Możesz użyć np. ListTile, Container, itp.
                    return Container(
                      width: 160,
                      height: 160,
                      margin: EdgeInsets.all(8.0), // Możesz dostosować marginesy według własnych preferencji
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: styles.todosPickerOn
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
                                  Text("${texts.habitsProgress}: ${achievement.value} / ${achievement.level[achievement.progress]}",
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
