// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DailyTodos.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyTodosAdapter extends TypeAdapter<DailyTodos> {
  @override
  final int typeId = 0;

  @override
  DailyTodos read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyTodos(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as DateTime,
      (fields[4] as List).cast<String>(),
      fields[5] as int,
      fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyTodos obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.importance)
      ..writeByte(6)
      ..write(obj.dailyTheme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyTodosAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
