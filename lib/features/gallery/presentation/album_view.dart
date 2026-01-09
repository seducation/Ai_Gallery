import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_gallery_app/features/gallery/domain/media_item.dart';
import 'package:ai_gallery_app/features/gallery/presentation/media_provider.dart';
import 'package:ai_gallery_app/features/gallery/presentation/gallery_grid.dart';

/// ---------------------------------------------------------------------------
/// LOCK PROVIDER (UI-level, safe)
/// ---------------------------------------------------------------------------

final folderLockProvider =
    StateNotifierProvider<FolderLockNotifier, Map<String, String>>(
  (ref) => FolderLockNotifier(),
);

class FolderLockNotifier extends StateNotifier<Map<String, String>> {
  FolderLockNotifier() : super({});

  bool isLocked(String key) => state.containsKey(key);

  bool verify(String key, String password) => state[key] == password;

  void setLock(String key, String password) {
    state = {...state, key: password};
  }

  void removeLock(String key) {
    final newState = Map<String, String>.from(state);
    newState.remove(key);
    state = newState;
  }
}

/// ---------------------------------------------------------------------------
/// ALBUM VIEW
/// ---------------------------------------------------------------------------

class AlbumView extends ConsumerStatefulWidget {
  const AlbumView({super.key});

  @override
  ConsumerState<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends ConsumerState<AlbumView> {
  String? expandedAlbum;

  @override
  Widget build(BuildContext context) {
    final mediaAsync = ref.watch(mediaNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Files'),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createAlbumDialog,
        child: const Icon(Icons.create_new_folder),
      ),
      body: mediaAsync.when(
        data: (items) {
          final Map<String, List<MediaItem>> albums = {};

          for (final item in items) {
            final album = item.albumName ?? 'Others';
            albums.putIfAbsent(album, () => []);
            albums[album]!.add(item);
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _storageCard(items.length),
              const SizedBox(height: 16),

              _categoryTile('Photos', items),
              _categoryTile('Videos', items),
              _categoryTile('Audio', items),
              _categoryTile('Documents', items),

              _lockedTile('Private Safe'),
              _lockedTile('Recently Deleted'),

              const Divider(height: 32),
              const Text(
                'Albums',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              for (final entry in albums.entries)
                _albumTile(entry.key, entry.value),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Error: $e')),
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// UI COMPONENTS
  /// -------------------------------------------------------------------------

  Widget _storageCard(int count) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All files',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const LinearProgressIndicator(value: 0.25),
            const SizedBox(height: 8),
            Text('$count items'),
          ],
        ),
      ),
    );
  }

  Widget _categoryTile(String name, List<MediaItem> items) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: Text(name),
      trailing: _lockIcon(name),
      onTap: () async {
        if (await _checkLock(name)) {
          _open(name, items);
        }
      },
    );
  }

  Widget _lockedTile(String name) {
    return ListTile(
      leading: const Icon(Icons.lock),
      title: Text(name),
      trailing: _lockIcon(name),
      onTap: () async {
        if (await _checkLock(name)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$name opened')),
          );
        }
      },
    );
  }

  Widget _albumTile(String name, List<MediaItem> items) {
    final isExpanded = expandedAlbum == name;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: Text(name),
            subtitle: Text('${items.length} items'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _lockIcon(name),
                Icon(isExpanded
                    ? Icons.expand_less
                    : Icons.expand_more),
              ],
            ),
            onTap: () async {
              if (await _checkLock(name)) {
                setState(() {
                  expandedAlbum =
                      isExpanded ? null : name;
                });
              }
            },
            onLongPress: () {
              _open(name, items);
            },
          ),
        ],
      ),
    );
  }

  Widget _lockIcon(String key) {
    final locked =
        ref.watch(folderLockProvider).containsKey(key);
    return Icon(
      locked ? Icons.lock : Icons.lock_open,
      size: 20,
    );
  }

  /// -------------------------------------------------------------------------
  /// LOCK HANDLING
  /// -------------------------------------------------------------------------

  Future<bool> _checkLock(String key) async {
    final locks = ref.read(folderLockProvider);
    if (!locks.containsKey(key)) return true;

    final controller = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Unlock $key'),
        content: TextField(
          controller: controller,
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final ok = ref
                  .read(folderLockProvider.notifier)
                  .verify(key, controller.text);
              Navigator.pop(context, ok);
            },
            child: const Text('Unlock'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// -------------------------------------------------------------------------
  /// NAVIGATION
  /// -------------------------------------------------------------------------

  void _open(String title, List<MediaItem> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: GalleryGrid(items: items),
        ),
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// CREATE ALBUM
  /// -------------------------------------------------------------------------

  void _createAlbumDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Album'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Album name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}