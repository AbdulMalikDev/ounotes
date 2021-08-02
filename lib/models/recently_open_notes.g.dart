// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_open_notes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentlyOpenedNotesAdapter extends TypeAdapter<RecentlyOpenedNotes> {
  @override
  final int typeId = 1;

  @override
  RecentlyOpenedNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentlyOpenedNotes(
      id: fields[0] as String,
      url: fields[1] as String,
      title: fields[2] as String,
      subjectName: fields[3] as String,
      author: fields[4] as String,
      view: fields[5] as int,
      pages: fields[6] as int,
      size: fields[7] as String,
      uploadDate: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RecentlyOpenedNotes obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.subjectName)
      ..writeByte(4)
      ..write(obj.author)
      ..writeByte(5)
      ..write(obj.view)
      ..writeByte(6)
      ..write(obj.pages)
      ..writeByte(7)
      ..write(obj.size)
      ..writeByte(8)
      ..write(obj.uploadDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlyOpenedNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
