import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_service.dart';
import '../../gallery/domain/media_item.dart';
import 'package:ai_engine/ai_engine.dart';

part 'search_service.g.dart';

@riverpod
class SearchService extends _$SearchService {
  final AiEngine _aiEngine = AiEngine();

  @override
  FutureOr<void> build() async {
    await _aiEngine.initialize();
  }

  Future<List<MediaItem>> searchByText(String query) async {
    // In a real app, we'd convert text to embedding using a CLIP text encoder
    // For now, we'll simulate it
    final queryEmbedding = List.generate(512, (index) => 0.1);

    final db = ref.read(databaseServiceProvider).value;
    if (db == null) return [];

    final allMedia = await db.mediaItems.where().findAll();

    // Sort by similarity
    allMedia.sort((a, b) {
      if (a.embeddings == null || b.embeddings == null) return 0;
      final simA = _aiEngine.calculateSimilarity(queryEmbedding, a.embeddings!);
      final simB = _aiEngine.calculateSimilarity(queryEmbedding, b.embeddings!);
      return simB.compareTo(simA);
    });

    return allMedia.take(20).toList();
  }
}
