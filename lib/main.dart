// ... existing imports ...
// Ensure you import FileFilter if it's in a different file

class GalleryHomeScreen extends ConsumerStatefulWidget { // Changed to ConsumerStatefulWidget
  const GalleryHomeScreen({super.key});

  @override
  ConsumerState<GalleryHomeScreen> createState() => _GalleryHomeScreenState();
}

class _GalleryHomeScreenState extends ConsumerState<GalleryHomeScreen> {
  int _selectedIndex = 0; // Keeping track of the bottom nav tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // Using a Stack or Container background if you want the "Glass" look for the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _selectedIndex == 0 ? 'Photos' : (_selectedIndex == 1 ? 'Albums' : 'AI Tools'),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          TimelineGallery(),
          Center(child: Text('Albums', style: TextStyle(color: Colors.white))),
          AIToolsScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        onFilterChanged: (filter) {
          // Update the Riverpod provider so TimelineGallery can react
          ref.read(galleryFilterProvider.notifier).state = filter;
        },
      ),
    );
  }
}
