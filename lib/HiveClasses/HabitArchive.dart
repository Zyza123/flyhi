import 'package:hive/hive.dart';
part 'HabitArchive.g.dart';

@HiveType(typeId: 3)
class HabitArchive extends HiveObject {

  @HiveField(0)
  late String name;

  @HiveField(1)
  late String icon;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late int frequency;

  @HiveField(4)
  late int fullTime;

  @HiveField(5)
  late int dayNumber;

  @HiveField(6)
  Map<DateTime, double> efficiency = {};

  @HiveField(7)
  late int dailyTheme;

  HabitArchive(this.name, this.icon, this.date, this.frequency, this.fullTime,
      this.dayNumber, this.efficiency, this.dailyTheme);
}