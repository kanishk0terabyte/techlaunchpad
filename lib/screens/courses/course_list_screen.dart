import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../widgets/course_card.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final List<String> _categories = [
    'All',
    'Programming',
    'AI & Data Science',
    'Web Dev',
    'Cloud',
    'Core Engineering',
  ];

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curated Courses 📖'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final isSelected = courseProvider.selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => courseProvider.filterByCategory(cat),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: courseProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : courseProvider.coursesList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_lesson_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            const Text('No courses available yet', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => courseProvider.fetchCourses(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: courseProvider.coursesList.length,
                          itemBuilder: (context, idx) {
                            final course = courseProvider.coursesList[idx];
                            return CourseCard(
                              course: course,
                              isBookmarked: bookmarkProvider.isBookmarked(course.id),
                              onBookmarkToggle: () => bookmarkProvider.toggleBookmark(course.id),
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
