import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ai_gallery_app/features/gallery/domain/media_item.dart';

part 'autotagging_service.g.dart';

@riverpod
class AutotaggingService extends _$AutotaggingService {
  @override
  FutureOr<void> build() async {}

  Future<MediaItem> processImage(MediaItem item) async {
    // Placeholder for autotagging
    await Future.delayed(const Duration(seconds: 2));
    item.labels = ['tag1', 'tag2', 'tag3'];
    item.embeddings = List.generate(128, (index) => 0.5);
    return item;
  }
}
