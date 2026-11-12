import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/resource_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../widgets/resource_card.dart';

class ResourceListScreen extends StatefulWidget {
  const ResourceListScreen({super.key});

  @override
  State<ResourceListScreen> createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends State<ResourceListScreen> {
  final List<String> _types = ['All', 'YouTube', 'Website', 'GitHub', 'Book', 'Blog'];

  @override
  Widget build(BuildContext context) {
    final resourceProvider = context.watch<ResourceProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Resources 📚'),
      ),
      body: Column(
        children: [
          // Types filter chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _types.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final type = _types[idx];
                final isSelected = resourceProvider.selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) => resourceProvider.filterByType(type),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: resourceProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : resourceProvider.resourcesList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.library_books_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            const Text('No resources available yet', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => resourceProvider.fetchResources(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: resourceProvider.resourcesList.length,
                          itemBuilder: (context, idx) {
                            final res = resourceProvider.resourcesList[idx];
                            return ResourceCard(
                              resource: res,
                              isBookmarked: bookmarkProvider.isBookmarked(res.id),
                              onBookmarkToggle: () => bookmarkProvider.toggleBookmark(res.id),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
