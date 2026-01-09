import 'package:flutter/material.dart';

enum GalleryFilter {
  photos,
  videos,
  all,
  photosAndVideos,
}

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final ValueChanged<GalleryFilter> onFilterChanged;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔽 Filter Button (Left side)
            _buildFilterButton(context),
            const SizedBox(width: 12),

            // Main Navigation Capsule
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavItem(0, 'Photos'),
                  const SizedBox(width: 4),
                  _buildNavItem(1, 'Albums'),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // ☰ Menu Button (Right side)
            GestureDetector(
              onTap: () => onItemSelected(2),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu,
                  color: selectedIndex == 2 ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FILTER MENU =================

  Widget _buildFilterButton(BuildContext context) {
    return PopupMenuButton<GalleryFilter>(
      onSelected: onFilterChanged,
      color: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: GalleryFilter.photos,
          child: _FilterItem('Only Photos'),
        ),
        PopupMenuItem(
          value: GalleryFilter.videos,
          child: _FilterItem('Only Videos'),
        ),
        PopupMenuItem(
          value: GalleryFilter.all,
          child: _FilterItem('All Files'),
        ),
        PopupMenuItem(
          value: GalleryFilter.photosAndVideos,
          child: _FilterItem('Photos & Videos'),
        ),
      ],
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.filter_list,
          color: Colors.white70,
        ),
      ),
    );
  }

  // ================= NAV ITEM =================

  Widget _buildNavItem(int index, String label) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  final String text;
  const _FilterItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }
}


Done ✅
I’ve added a filter icon on the left, matching the same circular UI as the hamburger/menu icon on the right.

✨ What you now have

Left filter button (Icons.filter_list)

Popup toggle menu (same style as hamburger)

Filter options:

1. Only Photos


2. Only Videos


3. All Files


4. Photos & Videos




🔧 How to use it in GalleryHomeScreen

You already referenced onFilterChanged, now just handle it:

CustomBottomNav(
  selectedIndex: _selectedIndex,
  onItemSelected: (index) {
    setState(() => _selectedIndex = index);
  },
  onFilterChanged: (filter) {
    // Example handling
    switch (filter) {
      case GalleryFilter.photos:
        // show only photos
        break;
      case GalleryFilter.videos:
        // show only videos
        break;
      case GalleryFilter.all:
        // show everything
        break;
      case GalleryFilter.photosAndVideos:
        // show both
        break;
    }
  },
)