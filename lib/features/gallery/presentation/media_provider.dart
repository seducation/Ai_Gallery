import 'package:ai_gallery_app/features/gallery/data/autotagging_service.dart';
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
      type: RequestType.all,
    );

    if (paths.isEmpty) return [];

    final List<AssetEntity> entities = await paths[0].getAssetListRange(
      start: 0,
      end: 100, // Limit for initial load
    );

    final dbService = ref.read(databaseServiceProvider.notifier);
    final autotaggingService = ref.read(autotaggingServiceProvider.notifier);
    final List<MediaItem> items = [];

    for (var entity in entities) {
      final thumbnailData = await entity.thumbnailDataWithSize(
        const ThumbnailSize(200, 200), // Request a 200x200 thumbnail
      );
      if (thumbnailData == null) continue;

      var item = MediaItem()
        ..thumbnailData = thumbnailData
        ..fileName = entity.title ?? 'Unknown'
        ..dateAdded = entity.createDateTime
        ..width = entity.width
        ..height = entity.height
        ..size = entity.size.width.toInt()
        ..isVideo = entity.type == AssetType.video
        ..mimeType = entity.mimeType;

      if (!item.isVideo) {
        item = await autotaggingService.processImage(item);
      }

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
