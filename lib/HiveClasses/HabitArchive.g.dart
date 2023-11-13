// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HabitArchive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitArchiveAdapter extends TypeAdapter<HabitArchive> {
  @override
  final int typeId = 3;

  @override
  HabitArchive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitArchive(
      fields[0] as String,
      fields[1] as String,
      fields[2] as DateTime,
      fields[3] as int,
      fields[4] as int,
      fields[5] as int,
      (fields[6] as Map).cast<DateTime, double>(),
      fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HabitArchive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.frequency)
      ..writeByte(4)
      ..write(obj.fullTime)
      ..writeByte(5)
      ..write(obj.dayNumber)
      ..writeByte(6)
      ..write(obj.efficiency)
      ..writeByte(7)
      ..write(obj.dailyTheme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitArchiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
