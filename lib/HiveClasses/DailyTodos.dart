import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'DailyTodos.g.dart';

@HiveType(typeId: 0)
class DailyTodos extends HiveObject {

  @HiveField(0)
  late String name;

  @HiveField(1)
  late String icon;

  @HiveField(2)
  late String status;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  List<String> time = ["",""];

  @HiveField(5)
  late int importance;

  @HiveField(6)
  late int dailyTheme;

  DailyTodos(this.name, this.icon, this.status, this.date, this.time, this.importance,
      this.dailyTheme);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'status': status,
      'date': date.toIso8601String(),
      'time': time,
      'importance': importance,
      'dailyTheme': dailyTheme,
    };
  }

  DailyTodos.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    status = json['status'];
    date = DateTime.parse(json['date']);
    time = List<String>.from(json['time']);
    importance = json['importance'];
    dailyTheme = json['dailyTheme'];
  }
}