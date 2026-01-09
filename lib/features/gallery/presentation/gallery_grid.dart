import 'package:ai_gallery_app/features/gallery/domain/media_item.dart';
import 'package:ai_gallery_app/features/gallery/presentation/media_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'media_provider.dart';

class GalleryGrid extends ConsumerWidget {
  final List<MediaItem>? items;
  const GalleryGrid({super.key, this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items != null) {
      return _buildGrid(context, items!);
    }

    final mediaAsync = ref.watch(mediaNotifierProvider);

    return mediaAsync.when(
      data: (items) => _buildGrid(context, items),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildGrid(BuildContext context, List<MediaItem> items) {
    if (items.isEmpty) {
      return const Center(child: Text('No media found'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MediaViewScreen(mediaItem: item),
              ),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(
                item.thumbnailData,
                fit: BoxFit.cover,
              ),
              if (item.isVideo)
                const Positioned(
                  right: 4,
                  top: 4,
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
