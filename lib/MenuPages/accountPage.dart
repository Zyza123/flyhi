import 'package:flutter/material.dart';
import 'package:flyhi/Language/LanguageProvider.dart';
import 'package:provider/provider.dart';
import '../Language/Texts.dart';
import '../Theme/DarkThemeProvider.dart';
import '../Theme/Styles.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final langChange = Provider.of<LanguageProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    Texts texts = Texts();
    texts.setTextLang(langChange.language);
    return Scaffold(
      backgroundColor: styles.mainBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right:20,top: 35),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text(texts.menu[3].toUpperCase(),style: TextStyle(
                      fontSize: 30,fontWeight: FontWeight.bold,color: styles.classicFont),),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(texts.settingsDarkMode,style: TextStyle(
                        color: styles.classicFont,fontSize: 18,),),
                    ),
                    Switch(
                      activeColor: styles.switchColors,
                      inactiveThumbColor: styles.switchColors,
                      value: themeChange.darkTheme,
                      onChanged: (bool? value) {
                        if (value != null) {
                          themeChange.darkTheme = value;
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        texts.settingsLang,
                        style: TextStyle(
                          color: styles.classicFont,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: langChange.language == "ENG" ? "english": "polski",
                        dropdownColor: styles.menuBg,
                        items: texts.langList.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language,style: TextStyle(color: styles.classicFont),),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                              if(newValue == "english" || newValue == "angielski"){
                                langChange.language = "ENG";
                              }
                              else{
                                langChange.language = "PL";
                              }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
