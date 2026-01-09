import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'media_provider.dart';
import '../domain/media_item.dart';

class TimelineGallery extends ConsumerWidget {
  const TimelineGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(mediaNotifierProvider);

    return mediaAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(
              child: Text('No media found',
                  style: TextStyle(color: Colors.white)));
        }

        // Group items by date
        final groupedItems = <String, List<MediaItem>>{};
        for (var item in items) {
          final dateStr = _formatDate(item.dateAdded);
          groupedItems.putIfAbsent(dateStr, () => []).add(item);
        }

        final dates = groupedItems.keys.toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final date = dates[index];
            final dateItems = groupedItems[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: dateItems.length,
                  itemBuilder: (context, itemIndex) {
                    final item = dateItems[itemIndex];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        File(item.localPath),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM yyyy').format(date);
    }
  }
}
