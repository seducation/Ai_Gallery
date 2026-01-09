import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/search_service.dart';
import '../../gallery/domain/media_item.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<MediaItem> _results = [];
  bool _isSearching = false;

  void _onSearch() async {
    setState(() => _isSearching = true);
    final results = await ref
        .read(searchServiceProvider.notifier)
        .searchByText(_searchController.text);
    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search photos (e.g. "dog", "beach")',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _onSearch(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _onSearch,
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? const Center(child: Text('Try searching for something!'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(2),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final item = _results[index];
                            return Image.memory(item.thumbnailData, fit: BoxFit.cover);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
