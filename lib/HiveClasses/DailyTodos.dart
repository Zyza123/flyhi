import 'dart:ui';
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
  late int importance;

  @HiveField(5)
  late int dailyTheme;

  DailyTodos(this.name, this.icon, this.status, this.date, this.importance,
      this.dailyTheme);
}