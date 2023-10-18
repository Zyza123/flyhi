import 'package:flutter/material.dart';
import 'package:flyhi/MenuPages/accountPage.dart';
import 'package:flyhi/MenuPages/achievementsPage.dart';
import 'package:flyhi/MenuPages/habitPage.dart';
import 'package:flyhi/MenuPages/homePage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flyhi/MenuPages/Theme/Styles.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import 'MenuPages/Theme/DarkThemeProvider.dart';

void main() {
  runApp(MainAppRoute());
}

class MainAppRoute extends StatefulWidget {
  const MainAppRoute({super.key});

  @override
  State<MainAppRoute> createState() => _MainAppRouteState();
}

class _MainAppRouteState extends State<MainAppRoute> {

  DarkThemeProvider themeChangeProvider =DarkThemeProvider();
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

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (_) {
          print('notified');
          return DarkThemeProvider();
        },
        child: Consumer<DarkThemeProvider>(
          builder: (context, value,child){
            Styles styles = Styles();
            styles.setColors(value.darkTheme);
            print('wartosc pod:');
            print(value.darkTheme);
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
                          text: 'Home',
                          border: currentIndex == 0?
                          Border.all(color: styles.fontMenuActive): Border(),
                        ),
                        GButton(
                          icon: Icons.event_available_outlined,
                          text: 'Habits',
                          border: currentIndex == 1?
                          Border.all(color: styles.fontMenuActive): Border(),
                        ),
                        GButton(
                          icon: Ionicons.sparkles_outline,
                          text: 'Rewards',
                          border: currentIndex == 2?
                          Border.all(color:  styles.fontMenuActive): Border(),
                        ),
                        GButton(
                          icon: Ionicons.settings_outline,
                          text: 'Settings',
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

