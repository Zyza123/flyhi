import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class AddDaily extends StatefulWidget {
  const AddDaily({super.key, required this.editMode});

  final bool editMode;

  @override
  State<AddDaily> createState() => _AddDailyState();
}

class _AddDailyState extends State<AddDaily> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    final langChange = Provider.of<LanguageProvider>(context);
    Texts texts = Texts();
    texts.setTextLang(langChange.language);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: styles.elementsInBg,
        title: Text(texts.addDailyAppBar,style: TextStyle(color: styles.classicFont),),
      ),
    );
  }
}
