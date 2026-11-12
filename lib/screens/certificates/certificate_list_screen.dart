import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/certificate_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../widgets/certificate_card.dart';

class CertificateListScreen extends StatefulWidget {
  const CertificateListScreen({super.key});

  @override
  State<CertificateListScreen> createState() => _CertificateListScreenState();
}

class _CertificateListScreenState extends State<CertificateListScreen> {
  final List<String> _platforms = [
    'All',
    'Google',
    'IBM',
    'Coursera',
    'Microsoft',
    'AWS',
    'FreeCodeCamp',
    'HackerRank',
  ];

  @override
  Widget build(BuildContext context) {
    final certProvider = context.watch<CertificateProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Certificates 🎓'),
      ),
      body: Column(
        children: [
          // Platform Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _platforms.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final platform = _platforms[idx];
                final isSelected = certProvider.selectedPlatform == platform;
                return ChoiceChip(
                  label: Text(platform),
                  selected: isSelected,
                  onSelected: (_) => certProvider.filterByPlatform(platform),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: certProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : certProvider.certificatesList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            const Text('No free certificates found', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => certProvider.fetchCertificates(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: certProvider.certificatesList.length,
                          itemBuilder: (context, idx) {
                            final cert = certProvider.certificatesList[idx];
                            return CertificateCard(
                              certificate: cert,
                              isBookmarked: bookmarkProvider.isBookmarked(cert.id),
                              onBookmarkToggle: () => bookmarkProvider.toggleBookmark(cert.id),
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
