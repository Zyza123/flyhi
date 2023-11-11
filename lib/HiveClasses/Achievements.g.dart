// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Achievements.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AchievementsAdapter extends TypeAdapter<Achievements> {
  @override
  final int typeId = 2;

  @override
  Achievements read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Achievements(
      fields[0] as String,
      fields[1] as String,
      (fields[3] as List).cast<int>(),
      progress: fields[2] as int,
      value: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Achievements obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.progress)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
