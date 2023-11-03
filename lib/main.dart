import 'package:flutter/material.dart';
import 'package:flyhi/HiveClasses/DailyTodos.dart';
import 'package:flyhi/Language/LanguageProvider.dart';
import 'package:flyhi/MenuPages/accountPage.dart';
import 'package:flyhi/MenuPages/achievementsPage.dart';
import 'package:flyhi/MenuPages/habit/habitPage.dart';
import 'package:flyhi/MenuPages/homePage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flyhi/Theme/Styles.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '/Theme/DarkThemeProvider.dart';
import 'HiveClasses/HabitTodos.dart';
import 'Language/Texts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(DailyTodosAdapter());
  Hive.registerAdapter(HabitTodosAdapter());
  await Hive.openBox('daily');
  await Hive.openBox('habits');
  runApp(MainAppRoute());
}

class MainAppRoute extends StatefulWidget {
  const MainAppRoute({super.key});

  @override
  State<MainAppRoute> createState() => _MainAppRouteState();
}

class _MainAppRouteState extends State<MainAppRoute> {

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  LanguageProvider languageProvider = LanguageProvider();
  int currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    HabitPage(),
    AchievementsPage(),
    AccountPage(),
  ];

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  void getCurrentAppLanguage() async {
    languageProvider.language =
        await languageProvider.languagePreference.getLang();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    getCurrentAppLanguage();
  }

  @override
  Widget build(BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => themeChangeProvider),
          ChangeNotifierProvider(create: (_) => languageProvider),
        ],
        child: Consumer2<DarkThemeProvider, LanguageProvider>(
          builder: (context, themeValue,langValue,child){
            Styles styles = Styles();
            styles.setColors(themeValue.darkTheme);
            Texts texts = Texts();
            texts.setTextLang(langValue.language);
            print('wartosc pod:');
            print(themeValue.darkTheme);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: SafeArea(
                  child: IndexedStack(
                    index: currentIndex,
                    children: _screens,
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 80,
                  color: styles.menuBg,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: GNav(
                      backgroundColor: styles.menuBg,
                      color: styles.fontMenuOff,
                      activeColor: styles.fontMenuActive,
                      tabBackgroundColor: styles.menuBg,
                      duration: Duration(milliseconds: 300),
                      gap: 8,
                      padding: EdgeInsets.all(12),
                      onTabChange: (index){
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      tabs: [
                        GButton(
                          icon: Ionicons.home_outline,
                          text: texts.menu[0],
                          border: currentIndex == 0?
                          Border.all(color: styles.fontMenuActive): Border(),
                        ),
                        GButton(
                          icon: Icons.event_available_outlined,
                          text: texts.menu[1],
                          border: currentIndex == 1?
                          Border.all(color: styles.fontMenuActive): Border(),
                        ),
                        GButton(
                          icon: Ionicons.sparkles_outline,
                          text: texts.menu[2],
                          border: currentIndex == 2?
                          Border.all(color:  styles.fontMenuActive): Border(),
                        ),
                        GButton(
                          icon: Ionicons.settings_outline,
                          text: texts.menu[3],
                          border: currentIndex == 3?
                          Border.all(color:  styles.fontMenuActive): Border(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        )
      );
  }
}

