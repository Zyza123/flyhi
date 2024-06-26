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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'progress': progress,
      'level': level,
      'value': value,
    };
  }
  Achievements.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    progress = json['progress'];
    level = List<int>.from(json['level']);
    value = json['value'];
  }
}