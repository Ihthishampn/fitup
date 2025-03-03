// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'musle_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MuscleModelAdapter extends TypeAdapter<MuscleModel> {
  @override
  final int typeId = 6;

  @override
  MuscleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MuscleModel(
      name: fields[0] as String,
      time: fields[1] as String,
      protein: fields[2] as double,
      calories: fields[3] as double,
      carbs: fields[4] as double,
      fats: fields[5] as double,
      imagePath: fields[6] as String?,
      isCompleted: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MuscleModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.protein)
      ..writeByte(3)
      ..write(obj.calories)
      ..writeByte(4)
      ..write(obj.carbs)
      ..writeByte(5)
      ..write(obj.fats)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MuscleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
