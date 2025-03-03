// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fitness_plan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FitnessPlanAdapter extends TypeAdapter<FitnessPlan> {
  @override
  final int typeId = 2;

  @override
  FitnessPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FitnessPlan(
      activity: fields[0] as String,
      duration: fields[1] as String,
      distance: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FitnessPlan obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.activity)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.distance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitnessPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
