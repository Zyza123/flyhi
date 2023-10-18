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
      appBar: AppBar(
        title: Text('Account Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
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
    );
  }
}
