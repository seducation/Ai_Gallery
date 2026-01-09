import 'dart:typed_data';
import 'package:ai_gallery_app/features/gallery/domain/media_item.dart';
import 'package:ai_gallery_app/features/gallery/presentation/gallery_grid.dart';
import 'package:ai_gallery_app/features/gallery/presentation/media_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart';

class SimilarPhotosScreen extends ConsumerWidget {
  final MediaItem mediaItem;

  const SimilarPhotosScreen({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(mediaNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Similar Photos'),
      ),
      body: mediaAsync.when(
        data: (items) {
          if (mediaItem.embeddings == null) {
            return const Center(child: Text('No embeddings found for this image.'));
          }

          final similarPhotos = _findSimilarPhotos(mediaItem, items);

          return GalleryGrid(items: similarPhotos);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  List<MediaItem> _findSimilarPhotos(MediaItem currentItem, List<MediaItem> allItems) {
    final similarPhotos = <MediaItem>[];
    final currentItemVector = Vector4.fromFloat64List(Float64List.fromList(currentItem.embeddings!));

    for (var item in allItems) {
      if (item == currentItem || item.embeddings == null) continue;

      final itemVector = Vector4.fromFloat64List(Float64List.fromList(item.embeddings!));
      final similarity = currentItemVector.dot(itemVector) / (currentItemVector.length * itemVector.length);

      if (similarity > 0.8) { // Adjust the threshold as needed
        similarPhotos.add(item);
      }
    }

    return similarPhotos;
  }
}
