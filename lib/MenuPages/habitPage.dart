import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Theme/DarkThemeProvider.dart';
import 'Theme/Styles.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
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
