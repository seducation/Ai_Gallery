# AlbumView – UI STRUCTURE ONLY (SAFE / NO LOGIC)

> ⚠️ This file is **UI‑ONLY**. No file access, no Kotlin/native deps, no MediaItem assumptions.
> Purpose: **visual review first**, logic will be connected later.

---

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlbumView extends ConsumerWidget {
  const AlbumView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Create Album (UI only)
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _categorySection(),
          const SizedBox(height: 16),
          _albumDropdownSection(),
        ],
      ),
    );
  }

  /// ---------------- CATEGORY GRID ----------------
  Widget _categorySection() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: const [
        _CategoryTile(icon: Icons.photo, label: 'Photos'),
        _CategoryTile(icon: Icons.videocam, label: 'Videos'),
        _CategoryTile(icon: Icons.music_note, label: 'Audio'),
        _CategoryTile(icon: Icons.description, label: 'Documents'),
        _CategoryTile(icon: Icons.archive, label: 'Archives'),
        _CategoryTile(icon: Icons.android, label: 'Apps'),
        _CategoryTile(icon: Icons.lock, label: 'Private Safe'),
        _CategoryTile(icon: Icons.delete, label: 'Recently Deleted'),
      ],
    );
  }

  /// ---------------- ALBUM DROPDOWN ----------------
  Widget _albumDropdownSection() {
    return ExpansionTile(
      title: const Text('My Albums'),
      leading: const Icon(Icons.folder),
      children: const [
        _AlbumTile(name: 'Camera', count: 120, locked: false),
        _AlbumTile(name: 'WhatsApp Images', count: 340, locked: false),
        _AlbumTile(name: 'Screenshots', count: 58, locked: false),
        _AlbumTile(name: 'Private Album', count: 12, locked: true),
      ],
    );
  }
}

/// ================= WIDGETS =================

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: Navigate later
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _AlbumTile extends StatelessWidget {
  final String name;
  final int count;
  final bool locked;

  const _AlbumTile({
    required this.name,
    required this.count,
    required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(locked ? Icons.lock : Icons.folder),
      title: Text(name),
      subtitle: Text('$count items'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Open album (locked albums will require auth later)
      },
    );
  }
}


 