import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'media_provider.dart';

class GalleryGrid extends ConsumerWidget {
  const GalleryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(mediaNotifierProvider);

    return mediaAsync.when(
      data: (items) {
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
                // Navigate to detail view
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(item.localPath),
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
