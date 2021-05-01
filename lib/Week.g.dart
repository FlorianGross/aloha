// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Week.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeekAdapter extends TypeAdapter<Week> {
  @override
  final int typeId = 1;

  @override
  Week read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Week(
      week: fields[0] as int?,
      plannedSE: fields[1] as double?,
      plannedDay: fields[2] as double?,
      SEthisWeek: fields[3] as double?,
      usedDays: fields[4] as double?,
      startdate: fields[5] as int?,
      endDate: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Week obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.week)
      ..writeByte(1)
      ..write(obj.plannedSE)
      ..writeByte(2)
      ..write(obj.plannedDay)
      ..writeByte(3)
      ..write(obj.SEthisWeek)
      ..writeByte(4)
      ..write(obj.usedDays)
      ..writeByte(5)
      ..write(obj.startdate)
      ..writeByte(6)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
