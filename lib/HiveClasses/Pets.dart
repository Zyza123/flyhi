import 'package:hive/hive.dart';
part 'Pets.g.dart';

@HiveType(typeId: 4)
class Pets extends HiveObject {

  @HiveField(0)
  late List<int> exp;

  @HiveField(1)
  late List<int> level;

  @HiveField(2)
  late List<String> name;

  @HiveField(3)
  late List<List<String>> avatars;

  @HiveField(4)
  late int chosenPet;

  Pets(this.exp,this.level,this.name,this.avatars,this.chosenPet);
}