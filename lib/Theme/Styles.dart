import 'dart:ui';

import 'package:flutter/material.dart';

class Styles{
 bool darkMode = true;
 late Color mainBackgroundColor;
 late Color elementsInBg;
 late Color menuBg;
 late Color classicFont;
 late Color fontMenuOff;
 late Color fontMenuActive;
 late Color switchColors;
 late Color todosPickerOn;
 late Color todosPickerOff;
 late Color sliderColorsAct;
 late Color sliderColorsInact;
 late Color achievementsColor;
 late Color dateColor;
 List<Color> nameColors = [Colors.orange,Colors.brown,Colors.yellow.shade800,Colors.green.shade600,
  Colors.brown,Colors.indigo.shade900];
 late Color whiteBlack;
 late Color blackWhite;


 void setColors(bool darkMode){
  mainBackgroundColor = !darkMode ?  Color(0xFFF1F1F1) : Color(0xFF161616);
  elementsInBg = !darkMode ? Color(0xFFF8F9F9) : Color(0xFF272727);
  menuBg = !darkMode ? Color(0xFFF1F1F1) : Color(0xFF161616);
  classicFont = !darkMode ? Color(0xFF000000) : Color(0xFFF9F9F9);
  fontMenuOff = !darkMode ? Colors.grey.shade700 : Colors.grey.shade500;
  fontMenuActive = !darkMode ? Colors.black : Colors.white;
  switchColors = !darkMode ? Color(0xFF2E4053) : Color(0xFFF1F1F1);
  todosPickerOn = !darkMode ? Colors.grey.shade300 : Colors.grey.shade800;
  todosPickerOff = !darkMode ? Color(0xFFF8F9F9) : Color(0xFF272727);
  sliderColorsAct = !darkMode ? Color(0xFF272727) : Color(0xFFF8F9F9);
  sliderColorsInact = Color(0xFF777777);
  achievementsColor = !darkMode ? Colors.grey.shade300 : Color(0xFF272727);
  dateColor = !darkMode ? Colors.grey.shade300 : Color(0xFF272727);
  nameColors[1] = !darkMode ? Colors.brown : Colors.brown.shade400;
  nameColors[4] = !darkMode ? Colors.brown : Colors.brown.shade400;
  nameColors[5] = !darkMode ? Colors.indigo.shade900 : Colors.indigo;
  whiteBlack = !darkMode ? Colors.white : Colors.black;
  blackWhite = !darkMode ? Colors.black : Colors.white;
 }
}