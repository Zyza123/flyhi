import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            "Pick your pet",
            style: TextStyle(color: styles.classicFont, fontSize: 16),
          ),
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5),
            ))));
  }
}
