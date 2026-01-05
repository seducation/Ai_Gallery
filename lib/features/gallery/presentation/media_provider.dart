import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/media_item.dart';
import '../../../core/database/database_service.dart';

part 'media_provider.g.dart';

@riverpod
class MediaNotifier extends _$MediaNotifier {
  @override
  Future<List<MediaItem>> build() async {
    return _fetchLocalMedia();
  }

  Future<List<MediaItem>> _fetchLocalMedia() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) return [];

    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      type: RequestType.common,
    );

    if (paths.isEmpty) return [];

    final List<AssetEntity> entities = await paths[0].getAssetListRange(
      start: 0,
      end: 100, // Limit for initial load
    );

    final dbService = ref.read(databaseServiceProvider.notifier);
    final List<MediaItem> items = [];

    for (var entity in entities) {
      final file = await entity.file;
      if (file == null) continue;

      final item = MediaItem()
        ..localPath = file.path
        ..fileName = entity.title ?? 'Unknown'
        ..dateAdded = entity.createDateTime
        ..width = entity.width
        ..height = entity.height
        ..size = await file.length()
        ..isVideo = entity.type == AssetType.video
        ..mimeType = entity.mimeType;

      items.add(item);
      await dbService.saveMediaItem(item);
    }

    return items;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchLocalMedia());
  }
}
