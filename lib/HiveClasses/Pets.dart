import 'dart:math';

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
  late List<List<int>> attributes;

  @HiveField(5)
  late int chosenPet;

  Pets(this.exp,this.level,this.name,this.avatars,this.attributes,this.chosenPet);

  Map<String, dynamic> toJson() {
    return {
      'exp': exp,
      'level': level,
      'name': name,
      'avatars': avatars,
      'attributes' : attributes,
      'chosenPet': chosenPet,
    };
  }

  Pets.fromJson(Map<String, dynamic> json) {
    exp = List<int>.from(json['exp']);
    level = List<int>.from(json['level']);
    name = List<String>.from(json['name']);
    avatars = (json['avatars'] as List).map((e) => List<String>.from(e)).toList();
    attributes = (json['attributes'] as List).map((e) => List<int>.from(e)).toList();
    chosenPet = json['chosenPet'];
  }

  void addExp(int experience){
    exp[chosenPet] += experience;
  }

  void checkLvlUp(){
    if(chosenPet != -1){
      int expNeeded = totalExp();
      if(exp[chosenPet] > expNeeded){
        int rest = 0;
        do{
          level[chosenPet] += 1;
          rest = exp[chosenPet] - expNeeded;
          exp[chosenPet] = rest;
          levelUpAttribute();
        } while (rest > totalExp());
      }
    }
  }

  void levelUpAttribute(){
    var rng = Random();
    List<int> indexes = [0,1,2];
    while(true){
      int picked = indexes[rng.nextInt(indexes.length)];
      if(attributes[chosenPet][picked] < 25){
        attributes[chosenPet][picked]++;
        break;
      }
      else{
        indexes.removeAt(picked);
        if(indexes.isEmpty){
          break;
        }
      }
    }
  }

  int totalExp(){
    return 150 + (50 *level[chosenPet]);
  }

  void changeName(String newName){
    name[chosenPet] = newName;
  }
}