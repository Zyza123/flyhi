import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Language/LanguageProvider.dart';
import '../../Language/Texts.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({super.key,required this.editMode});
  final bool editMode;

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
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
            onPressed: (){Navigator.pop(context);}
        ),
        backgroundColor: styles.elementsInBg,
        title: Row(
          children: [
            Text(
              widget.editMode == false ? texts.addHabitAppBar : texts.modifyHabitAppBar,
              style: TextStyle(color: styles.classicFont,fontSize: 16),
            ),
            Spacer(), // Dodaj przerwę, aby przesunąć "Zapisz" na prawą stronę
            GestureDetector(
              onTap: () async {
                  Navigator.pop(context);
              },
              child: Row(
                children: [
                  Text(texts.addSave, style: TextStyle(color: styles.classicFont,fontSize: 16)),
                  Icon(Icons.check, color: styles.classicFont,size: 18,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
