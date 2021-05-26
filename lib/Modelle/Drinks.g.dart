// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Drinks.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrinksAdapter extends TypeAdapter<Drinks> {
  @override
  final int typeId = 0;

  @override
  Drinks read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Drinks(
      name: fields[0] as String?,
      uri: fields[1] as String?,
      date: fields[2] as int?,
      volume: fields[3] as double?,
      volumepart: fields[4] as double?,
      session: fields[5] as int?,
      week: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Drinks obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.uri)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.volume)
      ..writeByte(4)
      ..write(obj.volumepart)
      ..writeByte(5)
      ..write(obj.session)
      ..writeByte(6)
      ..write(obj.week);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrinksAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
