import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/gallery/domain/media_item.dart';

part 'database_service.g.dart';

@Riverpod(keepAlive: true)
class DatabaseService extends _$DatabaseService {
  late Isar _isar;

  @override
  Future<Isar> build() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [MediaItemSchema],
      directory: dir.path,
    );
    return _isar;
  }

  Isar get isar => _isar;

  Future<void> saveMediaItem(MediaItem item) async {
    await _isar.writeTxn(() async {
      await _isar.mediaItems.put(item);
    });
  }

  Future<List<MediaItem>> getAllMedia() async {
    return await _isar.mediaItems.where().sortByDateAddedDesc().findAll();
  }

  Future<List<MediaItem>> searchByLabel(String query) async {
    return await _isar.mediaItems
        .filter()
        .labelsElementContains(query, caseSensitive: false)
        .findAll();
  }
}
