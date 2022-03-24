// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadAdapter extends TypeAdapter<Download> {
  @override
  final int typeId = 0;

  @override
  Download read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Download(
      id: fields[0] as String,
      path: fields[1] as String,
      title: fields[2] as String,
      subjectName: fields[3] as String,
      author: fields[4] as String,
      view: fields[5] as int,
      pages: fields[6] as int,
      size: fields[7] as String,
      uploadDate: fields[8] as DateTime,
      semester: fields[9] as String,
      branch: fields[10] as String,
      year: fields[11] as String,
      type: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Download obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.path)
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
      ..write(obj.uploadDate)
      ..writeByte(9)
      ..write(obj.semester)
      ..writeByte(10)
      ..write(obj.branch)
      ..writeByte(11)
      ..write(obj.year)
      ..writeByte(12)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
