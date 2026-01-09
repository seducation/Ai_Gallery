import 'package:ai_gallery_app/features/gallery/domain/media_item.dart';
import 'package:ai_gallery_app/features/gallery/presentation/gallery_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_gallery_app/features/gallery/presentation/media_provider.dart';

class AlbumView extends ConsumerWidget {
  const AlbumView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(mediaNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Files'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // create album
        child: const Icon(Icons.add),
      ),
      body: mediaAsync.when(
        data: (media) {
          final photos = media.where((item) => item.path.endsWith('.jpg') || item.path.endsWith('.png')).toList();
          final videos = media.where((item) => item.path.endsWith('.mp4')).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _storageCard(),
              const SizedBox(height: 16),
              _categoryGrid(context, photos, videos),
              const SizedBox(height: 24),
              _sectionTitle('Your Albums'),
              _userAlbumsRow(),
              const SizedBox(height: 24),
              _sectionTitle('Albums'),
              _albumTile('Camera', 245),
              _albumTile('WhatsApp Images', 120),
              _albumTile('Screenshots', 89, locked: true),
              const SizedBox(height: 16),
              _sectionTitle('Secure'),
              _secureTile('Private Safe', Icons.lock),
              _secureTile('Recently Deleted', Icons.delete),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _storageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('All files', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        const Text('60.4 GB / 256 GB', style: TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        const LinearProgressIndicator(value: 0.24),
      ]),
    );
  }

  Widget _categoryGrid(BuildContext context, List<MediaItem> photos, List<MediaItem> videos) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _CategoryTile(
          icon: Icons.image,
          label: 'Photos',
          count: '${photos.length}',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: const Text('Photos')),
                  body: GalleryGrid(items: photos),
                ),
              ),
            );
          },
        ),
        _CategoryTile(
          icon: Icons.videocam,
          label: 'Videos',
          count: '${videos.length}',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: const Text('Videos')),
                  body: GalleryGrid(items: videos),
                ),
              ),
            );
          },
        ),
        _CategoryTile(icon: Icons.music_note, label: 'Audio', count: '4'),
        _CategoryTile(icon: Icons.description, label: 'Documents', count: '53'),
        _CategoryTile(icon: Icons.android, label: 'APKs', count: '7'),
        _CategoryTile(icon: Icons.archive, label: 'Archives', count: '11'),
        _CategoryTile(icon: Icons.apps, label: 'Apps', count: '59'),
      ],
    );
  }

  Widget _userAlbumsRow() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _UserAlbumTile(create: true),
          _UserAlbumTile(name: 'Travel'),
          _UserAlbumTile(name: 'Family'),
          _UserAlbumTile(name: 'Work'),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _albumTile(String name, int count, {bool locked = false}) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: Text(name),
      subtitle: Text('$count items'),
      trailing: locked ? const Icon(Icons.lock, size: 18) : null,
      onTap: () {},
    );
  }

  Widget _secureTile(String name, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

class _UserAlbumTile extends StatelessWidget {
  final String? name;
  final bool create;

  const _UserAlbumTile({this.name, this.create = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 110,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(create ? Icons.add : Icons.folder, size: 32),
              const SizedBox(height: 8),
              Text(create ? 'Create Album' : name!, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final VoidCallback? onTap;

  const _CategoryTile({required this.icon, required this.label, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(count, style: const TextStyle(color: Colors.grey)),
        ]),
      ),
    );
  }
}
