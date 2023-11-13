import 'package:hive/hive.dart';
part 'Achievements.g.dart';

@HiveType(typeId: 2)
class Achievements extends HiveObject {

  @HiveField(0)
  late String name;

  @HiveField(1)
  late String image;

  @HiveField(2)
  late int progress;

  @HiveField(3)
  late List<int> level;

  @HiveField(4)
  late int value;

  Achievements(this.name, this.image, this.level, {this.progress = 0, this.value = 0} );
}