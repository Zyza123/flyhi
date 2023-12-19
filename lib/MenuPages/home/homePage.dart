import 'package:flutter/material.dart';
import 'package:flyhi/MenuPages/home/selectPetPage.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../HiveClasses/Pets.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Box pets;
  late Pets pet;

  void loadPetsInstance(){
    pets.add(Pets([0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0],
        ["Tiger","Bear","Lion","Wolf","Deer","Monkey"],
        [["tiger1.png","tiger2.png","tiger3.png","tiger4.png","tiger5.png"]],
        -1));
  }

  @override
  void initState() {
    pets = Hive.box('pets');
    if(pets.isEmpty){
      loadPetsInstance();
    }
    pet = pets.getAt(0);
    //pet.chosenPet = -1;
    //pets.putAt(0, pet);
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

    Widget petWidget;
    if (pets.getAt(0).chosenPet == -1) {
      petWidget = GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SelectPetPage()
              ));
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.all(8), // Add padding if needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  Icons.ads_click,
                  size: MediaQuery.of(context).size.height * 0.10,
                  color: styles.fontMenuOff
              ),
              SizedBox(height: 15,),
              Text("Pick your Pet",style: TextStyle(fontSize: 20,color: styles.fontMenuOff),),
            ],
          ),
        ),
      );
    } else {
      petWidget = Image.asset('assets/pets/tiger/${pet.avatars[pet.chosenPet][pet.level[pet.chosenPet]]}',
        height: MediaQuery.of(context).size.height*0.4);
    }

    return Scaffold(
      backgroundColor: styles.mainBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right:20,top: 25),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(texts.menu[0].toUpperCase(),style: TextStyle(
                    fontSize: 30,fontWeight: FontWeight.bold,color: styles.classicFont),),
              ),
              SizedBox(height: 25,),
              petWidget,
            ],
          ),
        ),
      )
    );
  }
}
