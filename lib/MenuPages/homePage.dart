import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Language/LanguageProvider.dart';
import '../Language/Texts.dart';
import '../Theme/DarkThemeProvider.dart';
import '../Theme/Styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
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
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right:20,top: 25),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text(texts.menu[0].toUpperCase(),style: TextStyle(
                      fontSize: 30,fontWeight: FontWeight.bold,color: styles.classicFont),),
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      )
    );
  }
}
