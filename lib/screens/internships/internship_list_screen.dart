import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/internship_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../widgets/internship_card.dart';

class InternshipListScreen extends StatefulWidget {
  const InternshipListScreen({super.key});

  @override
  State<InternshipListScreen> createState() => _InternshipListScreenState();
}

class _InternshipListScreenState extends State<InternshipListScreen> {
  final List<String> _types = ['All', 'Remote', 'Onsite', 'Hybrid'];

  @override
  Widget build(BuildContext context) {
    final internshipProvider = context.watch<InternshipProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Internships & Jobs 💼'),
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _types.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final type = _types[idx];
                final isSelected = internshipProvider.selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) => internshipProvider.filterByType(type),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: internshipProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : internshipProvider.internshipsList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.work_outline_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            const Text('No internship listings found', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => internshipProvider.fetchInternships(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: internshipProvider.internshipsList.length,
                          itemBuilder: (context, idx) {
                            final internship = internshipProvider.internshipsList[idx];
                            return InternshipCard(
                              internship: internship,
                              isBookmarked: bookmarkProvider.isBookmarked(internship.id),
                              onBookmarkToggle: () => bookmarkProvider.toggleBookmark(internship.id),
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
