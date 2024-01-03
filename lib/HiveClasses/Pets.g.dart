// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Pets.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetsAdapter extends TypeAdapter<Pets> {
  @override
  final int typeId = 4;

  @override
  Pets read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pets(
      (fields[0] as List).cast<int>(),
      (fields[1] as List).cast<int>(),
      (fields[2] as List).cast<String>(),
      (fields[3] as List)
          .map((dynamic e) => (e as List).cast<String>())
          .toList(),
      (fields[4] as List).map((dynamic e) => (e as List).cast<int>()).toList(),
      fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Pets obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.exp)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.avatars)
      ..writeByte(4)
      ..write(obj.attributes)
      ..writeByte(5)
      ..write(obj.chosenPet);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
