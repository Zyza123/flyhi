import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Theme/DarkThemeProvider.dart';
import 'Theme/Styles.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
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
                  child: Text("Settings",style: TextStyle(
                    color: styles.classicFont,fontSize: 24,),),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text("Dark mode:",style: TextStyle(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
