import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/gallery/domain/media_item.dart';

part 'database_service.g.dart';

@Riverpod(keepAlive: true)
class DatabaseService extends _$DatabaseService {
  late Box<MediaItem> _mediaBox;

  @override
  Future<Box<MediaItem>> build() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    Hive.registerAdapter(MediaItemAdapter());
    _mediaBox = await Hive.openBox<MediaItem>('media_items');
    return _mediaBox;
  }

  Box<MediaItem> get mediaBox => _mediaBox;

  Future<void> saveMediaItem(MediaItem item) async {
    await _mediaBox.put(item.localPath, item);
  }

  Future<List<MediaItem>> getAllMedia() async {
    return _mediaBox.values.toList()..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
  }

  Future<List<MediaItem>> searchByLabel(String query) async {
    return _mediaBox.values
        .where((item) =>
            item.labels?.any((label) => label.toLowerCase().contains(query.toLowerCase())) ??
            false)
        .toList();
  }
}
