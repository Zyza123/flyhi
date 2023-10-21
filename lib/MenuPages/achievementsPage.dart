import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Theme/DarkThemeProvider.dart';
import '../Theme/Styles.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
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
