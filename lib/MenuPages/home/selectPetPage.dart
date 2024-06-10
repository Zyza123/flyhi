import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../HiveClasses/Pets.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class SelectPetPage extends StatefulWidget {
  const SelectPetPage({super.key});

  @override
  State<SelectPetPage> createState() => _SelectPetPageState();
}

class _SelectPetPageState extends State<SelectPetPage> {

  late Box pets;
  late Pets pet; // Dodano stan dla każdego załadowanego obrazu

  int getPetLevel(int level){
    int petlevel = (level / 10).toInt();
    return petlevel;
  }

  @override
  void initState() {
    super.initState();
    pets = Hive.box('pets');
    pet = pets.getAt(0);
    // Inicjalizacja stanu załadowania obrazów
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    final langChange = Provider.of<LanguageProvider>(context);
    Texts texts = Texts(language: langChange.language);
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
            texts.texts.pickPetText,
            style: TextStyle(color: styles.classicFont, fontSize: 16),
          ),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: GridView.builder(
              itemCount: pet.avatars.length, // Number of items in your grid
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10, // Horizontal space between items
                mainAxisSpacing: 10, // Vertical space between items
                childAspectRatio: 3 / 4, // Aspect ratio of each grid item
              ),
              itemBuilder: (context, index) {
                int petLevel = getPetLevel(pet.level[index]);
                return GestureDetector(
                  onTap: () {
                    pet.chosenPet = index;
                    setState(() {
                      pets.putAt(0, pet);
                    });
                    Navigator.pop(context, true);
                  },
                  child: Column(
                    children: [
                      FadeInImage(
                        key: ValueKey<AssetImage>(AssetImage('assets/pets/${pet.avatars[index][petLevel]}')),
                        fit: BoxFit.scaleDown,
                        placeholder: const AssetImage('assets/empty.png'),
                        image: AssetImage('assets/pets/${pet.avatars[index][petLevel]}'),
                      ),
                      Text(
                        pet.name[index],
                        style: TextStyle(fontSize: 22,color: styles.classicFont),
                      ),
                      Text(
                        "${texts.texts.homeLevel} " + pet.level[index].toString(),
                        style: TextStyle(fontSize: 19,color: styles.classicFont),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }
}
