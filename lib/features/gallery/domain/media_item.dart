import 'package:isar/isar.dart';

part 'media_item.g.dart';

@collection
class MediaItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String localPath;

  late String fileName;

  late DateTime dateAdded;

  late int width;

  late int height;

  late int size;

  @Index()
  late bool isVideo;

  String? mimeType;

  // AI Metadata
  List<double>? embeddings;

  List<String>? labels;

  @Index()
  bool isFavorite = false;

  @Index()
  String? albumName;

  // Location data
  double? latitude;
  double? longitude;
}
