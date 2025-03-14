// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdvanceWorkoutAdapter extends TypeAdapter<AdvanceWorkout> {
  @override
  final int typeId = 4;

  @override
  AdvanceWorkout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdvanceWorkout(
      name: fields[0] as String,
      duration: fields[1] as String,
      goal: fields[2] as String,
      count: fields[3] as String,
      image: fields[4] as String,
      completed: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AdvanceWorkout obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.goal)
      ..writeByte(3)
      ..write(obj.count)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdvanceWorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
