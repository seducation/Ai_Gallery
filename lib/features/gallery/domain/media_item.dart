import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'media_item.g.dart';

@HiveType(typeId: 0)
class MediaItem extends HiveObject {
  @HiveField(0)
  late Uint8List thumbnailData;

  @HiveField(1)
  late String fileName;

  @HiveField(2)
  late DateTime dateAdded;

  @HiveField(3)
  late int width;

  @HiveField(4)
  late int height;

  @HiveField(5)
  late int size;

  @HiveField(6)
  late bool isVideo;

  @HiveField(7)
  String? mimeType;

  // AI Metadata
  @HiveField(8)
  List<double>? embeddings;

  @HiveField(9)
  List<String>? labels;

  @HiveField(10)
  bool isFavorite = false;

  @HiveField(11)
  String? albumName;

  // Location data
  @HiveField(12)
  double? latitude;

  @HiveField(13)
  double? longitude;

  // Non-Hive fields
  late String path;
}
