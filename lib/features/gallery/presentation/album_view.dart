import 'package:ai_gallery_app/features/gallery/domain/media_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_gallery_app/features/gallery/presentation/media_provider.dart';
import 'package:ai_gallery_app/features/gallery/presentation/gallery_grid.dart';

class AlbumView extends ConsumerWidget {
  const AlbumView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(mediaNotifierProvider);

    return mediaAsync.when(
      data: (items) {
        final albums = <String, List<MediaItem>>{};
        for (var item in items) {
          final albumName = item.albumName;
          if (albumName != null) {
            if (!albums.containsKey(albumName)) {
              albums[albumName] = [];
            }
            albums[albumName]!.add(item);
          }
        }

        return ListView.builder(
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final albumName = albums.keys.elementAt(index);
            final albumItems = albums[albumName]!;
            return ListTile(
              title: Text(albumName),
              subtitle: Text('${albumItems.length} items'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: Text(albumName)),
                      body: GalleryGrid(items: albumItems),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
