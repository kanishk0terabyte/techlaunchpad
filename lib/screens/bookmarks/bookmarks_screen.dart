import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/resource_provider.dart';
import '../../providers/certificate_provider.dart';
import '../../providers/internship_provider.dart';
import '../../widgets/resource_card.dart';
import '../../widgets/certificate_card.dart';
import '../../widgets/internship_card.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = context.watch<BookmarkProvider>();
    final resources = context.watch<ResourceProvider>().resourcesList;
    final certs = context.watch<CertificateProvider>().certificatesList;
    final internships = context.watch<InternshipProvider>().internshipsList;

    final bookmarkedResources = resources.where((r) => bookmarkProvider.isBookmarked(r.id)).toList();
    final bookmarkedCerts = certs.where((c) => bookmarkProvider.isBookmarked(c.id)).toList();
    final bookmarkedInternships = internships.where((i) => bookmarkProvider.isBookmarked(i.id)).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saved Bookmarks 🔖'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Resources'),
              Tab(text: 'Certificates'),
              Tab(text: 'Internships'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            bookmarkedResources.isEmpty
                ? _buildEmptyTab('No saved resources yet')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: bookmarkedResources.length,
                    itemBuilder: (context, idx) {
                      final item = bookmarkedResources[idx];
                      return ResourceCard(
                        resource: item,
                        isBookmarked: true,
                        onBookmarkToggle: () => bookmarkProvider.toggleBookmark(item.id),
                      );
                    },
                  ),
            bookmarkedCerts.isEmpty
                ? _buildEmptyTab('No saved certificates yet')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: bookmarkedCerts.length,
                    itemBuilder: (context, idx) {
                      final item = bookmarkedCerts[idx];
                      return CertificateCard(
                        certificate: item,
                        isBookmarked: true,
                        onBookmarkToggle: () => bookmarkProvider.toggleBookmark(item.id),
                      );
                    },
                  ),
            bookmarkedInternships.isEmpty
                ? _buildEmptyTab('No saved internships yet')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: bookmarkedInternships.length,
                    itemBuilder: (context, idx) {
                      final item = bookmarkedInternships[idx];
                      return InternshipCard(
                        internship: item,
                        isBookmarked: true,
                        onBookmarkToggle: () => bookmarkProvider.toggleBookmark(item.id),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTab(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded, size: 56, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(msg, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
