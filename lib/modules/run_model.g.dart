// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RunRecordAdapter extends TypeAdapter<RunRecord> {
  @override
  final int typeId = 37;

  @override
  RunRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RunRecord(
      milliseconds: fields[0] as int,
      date: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RunRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.milliseconds)
      ..writeByte(1)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompletedDayAdapter extends TypeAdapter<CompletedDay> {
  @override
  final int typeId = 38;

  @override
  CompletedDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompletedDay(
      day: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CompletedDay obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.day);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
