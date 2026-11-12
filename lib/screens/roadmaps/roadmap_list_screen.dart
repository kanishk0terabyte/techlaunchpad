import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/roadmap_provider.dart';
import '../../widgets/roadmap_card.dart';

class RoadmapListScreen extends StatefulWidget {
  const RoadmapListScreen({super.key});

  @override
  State<RoadmapListScreen> createState() => _RoadmapListScreenState();
}

class _RoadmapListScreenState extends State<RoadmapListScreen> {
  final List<String> _categories = [
    'All',
    'Frontend',
    'Backend',
    'Full Stack',
    'AI & ML',
    'DevOps',
    'Mobile',
    'Cyber Security',
  ];

  @override
  Widget build(BuildContext context) {
    final roadmapProvider = context.watch<RoadmapProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Roadmaps 🗺️'),
      ),
      body: Column(
        children: [
          // Category chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final isSelected = roadmapProvider.selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => roadmapProvider.filterByCategory(cat),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: roadmapProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : roadmapProvider.roadmapsList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.alt_route_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            const Text('No roadmaps available yet', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => roadmapProvider.fetchRoadmaps(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: roadmapProvider.roadmapsList.length,
                          itemBuilder: (context, idx) {
                            final rm = roadmapProvider.roadmapsList[idx];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: RoadmapCard(
                                icon: _getIconForCategory(rm.category),
                                title: rm.title,
                                subtitle: rm.description,
                                totalSteps: rm.steps.length,
                                category: rm.category,
                                onTap: () => context.push('/roadmaps/${rm.id}'),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'frontend':
        return Icons.web_rounded;
      case 'backend':
        return Icons.dns_rounded;
      case 'ai & ml':
      case 'ai/ml':
        return Icons.psychology_rounded;
      case 'devops':
        return Icons.all_inclusive_rounded;
      case 'mobile':
        return Icons.phone_android_rounded;
      case 'cyber security':
        return Icons.security_rounded;
      default:
        return Icons.code_rounded;
    }
  }
}
