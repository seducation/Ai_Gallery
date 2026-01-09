import 'package:ai_gallery_app/features/gallery/presentation/gallery_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_gallery_app/features/gallery/presentation/media_provider.dart';

class TimelineGallery extends ConsumerWidget {
  const TimelineGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(mediaNotifierProvider);

    return mediaAsync.when(
      data: (media) => GalleryGrid(items: media),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
