import 'package:flutter/material.dart';

// Enum to manage the filter state
enum FileFilter { onlyPhoto, onlyVideo, allFiles, photoAndVideo }

class CustomBottomNav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final Function(FileFilter) onFilterChanged; // Callback for filtering logic

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onFilterChanged,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  FileFilter _currentFilter = FileFilter.allFiles;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            
            // Filter Button with Toggle Menu
            _buildFilterMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterMenu() {
    return Theme(
      // This removes the default padding from the popup menu for a cleaner look
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: PopupMenuButton<FileFilter>(
        initialValue: _currentFilter,
        icon: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.tune_rounded, // Better "filter/tune" icon
            color: Colors.white,
          ),
        ),
        offset: const Offset(0, -220), // Adjust this to make the menu pop "up"
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (FileFilter result) {
          setState(() {
            _currentFilter = result;
          });
          widget.onFilterChanged(result);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<FileFilter>>[
          const PopupMenuItem(value: FileFilter.onlyPhoto, child: Text('Only Photo')),
          const PopupMenuItem(value: FileFilter.onlyVideo, child: Text('Only Video')),
          const PopupMenuItem(value: FileFilter.allFiles, child: Text('All Files')),
          const PopupMenuItem(value: FileFilter.photoAndVideo, child: Text('Photo and Video')),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label) {
    final isSelected = widget.selectedIndex == index;
    return GestureDetector(
      onTap: () => widget.onItemSelected(index),
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
