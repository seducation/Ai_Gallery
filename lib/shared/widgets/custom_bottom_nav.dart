import 'package:flutter/material.dart';

/// Gallery filter options
enum GalleryFilter {
  photos,
  videos,
  all,
  photosAndVideos,
}

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
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
            // Left: Filter button
            _buildFilterButton(context),
            const SizedBox(width: 12),

            // Center: Navigation capsule
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: HSLColor.fromColor(Colors.black).withLightness(0.2).toColor(),
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

            // Right: Menu button
            GestureDetector(
              onTap: () => onItemSelected(2),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: HSLColor.fromColor(Colors.black).withLightness(0.2).toColor(),
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

  // ================= FILTER BUTTON =================

  Widget _buildFilterButton(BuildContext context) {
    return PopupMenuButton<GalleryFilter>(
      onSelected: onFilterChanged,
      color: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: GalleryFilter.photos,
          child: Text('Only Photos', style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: GalleryFilter.videos,
          child: Text('Only Videos', style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: GalleryFilter.all,
          child: Text('All Files', style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: GalleryFilter.photosAndVideos,
          child:
              Text('Photos & Videos', style: TextStyle(color: Colors.white)),
        ),
      ],
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: HSLColor.fromColor(Colors.black).withLightness(0.2).toColor(),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.filter_list, color: Colors.white70),
      ),
    );
  }

  // ================= NAV ITEM =================

  Widget _buildNavItem(int index, String label) {
    final bool isSelected = selectedIndex == index;

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
