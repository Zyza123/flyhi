import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flyhi/HiveClasses/Achievements.dart';
import 'package:flyhi/HiveClasses/DailyTodos.dart';
import 'package:flyhi/HiveClasses/HabitArchive.dart';
import 'package:flyhi/Language/LanguageProvider.dart';
import 'package:flyhi/MenuPages/accountPage.dart';
import 'package:flyhi/MenuPages/achievementsPage.dart';
import 'package:flyhi/MenuPages/habit/habitPage.dart';
import 'package:flyhi/MenuPages/home/homePage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flyhi/Theme/Styles.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '/Theme/DarkThemeProvider.dart';
import 'HiveClasses/HabitTodos.dart';
import 'HiveClasses/Pets.dart';
import 'Language/Texts.dart';
import 'Notification/NotificationManager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager().initNotification();
  await setup();
  //tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(DailyTodosAdapter());
  Hive.registerAdapter(HabitTodosAdapter());
  Hive.registerAdapter(AchievementsAdapter());
  Hive.registerAdapter(HabitArchiveAdapter());
    Hive.registerAdapter(PetsAdapter());
  await Hive.openBox('daily');
  await Hive.openBox('habits');
  await Hive.openBox('achievements');
  await Hive.openBox('habitsArchive');
  await Hive.openBox('pets');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => {
    runApp(const MainAppRoute())
  });
}

Future<void> setup() async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));
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
  late Box pets;

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

  void loadPetsInstance(){
    pets.add(Pets([0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0],
        ["Tiger","Bear","Lion","Wolf","Deer","Monkey"],
        [["tiger/tiger1.png","tiger/tiger2.png","tiger/tiger3.png","tiger/tiger4.png","tiger/tiger5.png"],
          ["bear/bear1.png","bear/bear2.png","bear/bear3.png","bear/bear4.png","bear/bear5.png"],
          ["lion/lion1.png","lion/lion2.png","lion/lion3.png","lion/lion4.png","lion/lion5.png"],
          ["wolf/wolf1.png","wolf/wolf2.png","wolf/wolf3.png","wolf/wolf4.png","wolf/wolf5.png"],
          ["deer/deer1.png","deer/deer2.png","deer/deer3.png","deer/deer4.png","deer/deer5.png"],
          ["gorilla/gorilla1.png","gorilla/gorilla2.png","gorilla/gorilla3.png","gorilla/gorilla4.png","gorilla/gorilla5.png"]],
        [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]],
        -1));
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    getCurrentAppLanguage();
    pets = Hive.box('pets');
    if(pets.isEmpty){
      loadPetsInstance();
    }
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
            Texts texts = Texts(language: langValue.language);
            return MaterialApp(
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en'),
                Locale('pl'),
              ],
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
                          text: texts.texts.menu[0],
                          border: currentIndex == 0?
                          Border.all(color: styles.fontMenuActive): Border(),
                        ),
                        GButton(
                          icon: Icons.event_available_outlined,
                          text: texts.texts.menu[1],
                          border: currentIndex == 1?
                          Border.all(color: styles.fontMenuActive): Border(),
                        ),
                        GButton(
                          icon: Ionicons.sparkles_outline,
                          text: texts.texts.menu[2],
                          border: currentIndex == 2?
                          Border.all(color:  styles.fontMenuActive): Border(),
                        ),
                        GButton(
                          icon: Ionicons.settings_outline,
                          text: texts.texts.menu[3],
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

