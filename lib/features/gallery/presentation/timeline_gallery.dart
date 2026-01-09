import 'package:ai_gallery_app/features/gallery/presentation/album_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'media_provider.dart';
import '../domain/media_item.dart';
import 'filter_provider.dart';
import 'gallery_grid.dart';

class TimelineGallery extends ConsumerStatefulWidget {
  const TimelineGallery({super.key});

  @override
  ConsumerState<TimelineGallery> createState() => _TimelineGalleryState();
}

class _TimelineGalleryState extends ConsumerState<TimelineGallery> {
  int _currentIndex = 0;

  final _views = [
    const TimelineView(),
    const AlbumView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Albums',
          ),
        ],
      ),
    );
  }
}

class TimelineView extends ConsumerStatefulWidget {
  const TimelineView({super.key});

  @override
  ConsumerState<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends ConsumerState<TimelineView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final mediaAsync = ref.watch(mediaNotifierProvider);
    final filter = ref.watch(galleryFilterNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          PopupMenuButton<GalleryFilter>(
            onSelected: (newFilter) => ref.read(galleryFilterNotifierProvider.notifier).setFilter(newFilter),
            itemBuilder: (context) => const [
              PopupMenuItem(value: GalleryFilter.all, child: Text('All')),
              PopupMenuItem(value: GalleryFilter.photos, child: Text('Photos')),
              PopupMenuItem(value: GalleryFilter.videos, child: Text('Videos')),
            ],
          ),
        ],
      ),
      body: mediaAsync.when(
        data: (items) {
          final filteredItems = _filterItems(items, filter, _searchQuery);

          if (filteredItems.isEmpty) {
            return const Center(
              child: Text(
                'No media found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final groupedItems = <String, List<MediaItem>>{};
          for (var item in filteredItems) {
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
                  // The GalleryGrid now handles the grid display and tap gestures
                  GalleryGrid(items: dateItems),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  List<MediaItem> _filterItems(List<MediaItem> items, GalleryFilter filter, String searchQuery) {
    var filteredItems = items;
    switch (filter) {
      case GalleryFilter.photos:
        filteredItems = filteredItems.where((item) => !item.isVideo).toList();
        break;
      case GalleryFilter.videos:
        filteredItems = filteredItems.where((item) => item.isVideo).toList();
        break;
      case GalleryFilter.all:
        break;
    }

    if (searchQuery.isNotEmpty) {
      filteredItems = filteredItems.where((item) {
        if (item.labels == null) return false;
        return item.labels!.any((label) => label.toLowerCase().contains(searchQuery.toLowerCase()));
      }).toList();
    }

    return filteredItems;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM yyyy').format(date);
    }
  }
}
