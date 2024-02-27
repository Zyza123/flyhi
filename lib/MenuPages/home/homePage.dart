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

  Future<void> _showEditNameDialog(BuildContext context, Color bg, Color font, String change, String insert) async {
    String newName = '';
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Użytkownik musi nacisnąć przycisk, aby zamknąć dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(change, style: TextStyle(color: font),),
          backgroundColor: bg,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    newName = value;
                  },
                  decoration: InputDecoration(
                    hintText: insert,
                    suffixStyle: TextStyle(color: font),
                    labelStyle: TextStyle(color: font),
                    hintStyle: TextStyle(color: font),
                    counterStyle: TextStyle(color: font),
                  ),
                  style: TextStyle(color: Colors.white), // This line sets the text color to white
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Cancel',style: TextStyle(color: font)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save',style: TextStyle(color: font)),
                  onPressed: () {
                    setState(() {
                      pet.changeName(newName);
                      pets.putAt(0, pet);
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    pets = Hive.box('pets');
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
    Texts texts = Texts(language: langChange.language);

    Widget petWidget;
    if (pets.getAt(0).chosenPet == -1) {
      petWidget = GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SelectPetPage()
              )).then((value) {
            if(value == true){
              setState(() {
                pet = pets.getAt(0);
              });
            }
          });
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
      int petLevel = pet.level[pet.chosenPet] != 0 ? pet.level[pet.chosenPet]~/10 : 0;
      petWidget =Column(
        children: [
          Image.asset(
            'assets/pets/${pet.avatars[pet.chosenPet][petLevel]}',
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Wyśrodkowanie w poziomie
            children: [
              Text(
                pet.name[pet.chosenPet],
                style: TextStyle(fontSize: 32,color: styles.nameColors[pet.chosenPet],fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Tekst wyśrodkowany w poziomie
              ),
              SizedBox(width: 30,),
              GestureDetector(
                onTap: () {
                    _showEditNameDialog(context,styles.elementsInBg, styles.classicFont, texts.texts.changePetName,
                      texts.texts.insertNewName);
                },
                child: Icon(
                  Icons.drive_file_rename_outline_rounded,
                  size: 32,
                  color:  styles.todosPickerOn,
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Wyśrodkowanie w poziomie
            children: [
              Text(
                "${texts.texts.homeLevel} "+pet.level[pet.chosenPet].toString(),
                style: TextStyle(fontSize: 23,color: styles.classicFont),
                textAlign: TextAlign.center, // Tekst wyśrodkowany w poziomie
              ),
              SizedBox(width: 25,),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  key: Key("12223"),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.decelerate,
                  tween: Tween<double>(
                    begin: 0,
                    end: 1,
                  ),
                  builder: (context, value, _) =>
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: pet.exp[pet.chosenPet].toDouble()/pet.totalExp(),
                          valueColor: AlwaysStoppedAnimation<Color>(styles.nameColors[pet.chosenPet]),
                          backgroundColor: styles.todosPickerOn,
                          minHeight: 18,
                        ),
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text("${pet.exp[pet.chosenPet]} / ${pet.totalExp()} EXP",
                style: TextStyle(fontSize: 23,color: styles.nameColors[pet.chosenPet],fontWeight: FontWeight.bold),),
            ),
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Container(
                width: 130,
                child: Text(
                  texts.texts.attributes1[pet.chosenPet],
                  style: TextStyle(fontSize: 20,color: styles.classicFont,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Tekst wyśrodkowany w poziomie
                  overflow: TextOverflow.ellipsis, // Use ellipsis for text overflow
                  maxLines: 1, // Ensure text does not exceed one line
                ),
              ),
              SizedBox(width: 25,),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  key: Key("111"),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.decelerate,
                  tween: Tween<double>(
                    begin: 0,
                    end: 1,
                  ),
                  builder: (context, value, _) =>
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (pet.attributes[pet.chosenPet][0])/25 <= 1 ? (pet.attributes[pet.chosenPet][0])/25 : 1,
                          valueColor: AlwaysStoppedAnimation<Color>(styles.nameColors[pet.chosenPet]),
                          backgroundColor: styles.todosPickerOn,
                          minHeight: 18,
                        ),
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Container(
                width: 130,
                child: Text(
                  texts.texts.attributes2[pet.chosenPet],
                  style: TextStyle(fontSize: 20,color: styles.classicFont, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Tekst wyśrodkowany w poziomie
                  overflow: TextOverflow.ellipsis, // Use ellipsis for text overflow
                  maxLines: 1, // Ensure text does not exceed one line
                ),
              ),
              SizedBox(width: 25,),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  key: Key("222"),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.decelerate,
                  tween: Tween<double>(
                    begin: 0,
                    end: 1,
                  ),
                  builder: (context, value, _) =>
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (pet.attributes[pet.chosenPet][1])/25 <= 1 ? (pet.attributes[pet.chosenPet][1])/25 : 1,
                          valueColor: AlwaysStoppedAnimation<Color>(styles.nameColors[pet.chosenPet]),
                          backgroundColor: styles.todosPickerOn,
                          minHeight: 18,
                        ),
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Container(
                width: 130,
                child: Text(
                  texts.texts.attributes3[pet.chosenPet],
                  style: TextStyle(fontSize: 20,color: styles.classicFont, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Tekst wyśrodkowany w poziomie
                  overflow: TextOverflow.ellipsis, // Use ellipsis for text overflow
                  maxLines: 1, // Ensure text does not exceed one line
                ),
              ),
              SizedBox(width: 25,),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  key: Key("333"),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.decelerate,
                  tween: Tween<double>(
                    begin: 0,
                    end: 1,
                  ),
                  builder: (context, value, _) =>
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (pet.attributes[pet.chosenPet][2])/25 <= 1 ? (pet.attributes[pet.chosenPet][2])/25 : 1,
                          valueColor: AlwaysStoppedAnimation<Color>(styles.nameColors[pet.chosenPet]),
                          backgroundColor: styles.todosPickerOn,
                          minHeight: 18,
                        ),
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: styles.nameColors[pet.chosenPet], // Twój obecny kolor
                width: 3,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SelectPetPage())
                ).then((value) {
                  if (value == true) {
                    setState(() {
                      pet = pets.getAt(0);
                    });
                  }
                });
              },
              child: Text(
                texts.texts.homeSelectButton,
                style: TextStyle(fontSize: 20, color: styles.nameColors[pet.chosenPet],fontWeight: FontWeight.bold), // Powiększenie czcionki do 28
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: styles.mainBackgroundColor, foregroundColor: styles.mainBackgroundColor, elevation: 0, // Kolor tekstu (czarny)
                minimumSize: const Size.fromHeight(40)),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: styles.mainBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0,right:15,top: 25),
        child: SingleChildScrollView( // Dodaj SingleChildScrollView tutaj
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(texts.texts.menu[0].toUpperCase(),style: TextStyle(
                    fontSize: 30,fontWeight: FontWeight.bold,color: styles.classicFont),),
              ),
              SizedBox(height: 10,),
              petWidget,
            ],
          ),
        ),
      ),
    );
  }
}
