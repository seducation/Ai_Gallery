// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaItemAdapter extends TypeAdapter<MediaItem> {
  @override
  final int typeId = 0;

  @override
  MediaItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaItem()
      ..localPath = fields[0] as String
      ..fileName = fields[1] as String
      ..dateAdded = fields[2] as DateTime
      ..width = fields[3] as int
      ..height = fields[4] as int
      ..size = fields[5] as int
      ..isVideo = fields[6] as bool
      ..mimeType = fields[7] as String?
      ..embeddings = (fields[8] as List?)?.cast<double>()
      ..labels = (fields[9] as List?)?.cast<String>()
      ..isFavorite = fields[10] as bool
      ..albumName = fields[11] as String?
      ..latitude = fields[12] as double?
      ..longitude = fields[13] as double?;
  }

  @override
  void write(BinaryWriter writer, MediaItem obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.localPath)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.dateAdded)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.isVideo)
      ..writeByte(7)
      ..write(obj.mimeType)
      ..writeByte(8)
      ..write(obj.embeddings)
      ..writeByte(9)
      ..write(obj.labels)
      ..writeByte(10)
      ..write(obj.isFavorite)
      ..writeByte(11)
      ..write(obj.albumName)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
