import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Theme/DarkThemeProvider.dart';
import '../Theme/Styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    return Scaffold(
      backgroundColor: styles.mainBackgroundColor,
    );
  }
}
