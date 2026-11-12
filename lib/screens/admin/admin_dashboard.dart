import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';
import '../../providers/roadmap_provider.dart';
import '../../providers/resource_provider.dart';
import '../../providers/certificate_provider.dart';
import '../../providers/internship_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/event_provider.dart';
import '../../config/routes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newsCount = context.watch<NewsProvider>().newsList.length;
    final roadmapCount = context.watch<RoadmapProvider>().roadmapsList.length;
    final resourceCount = context.watch<ResourceProvider>().resourcesList.length;
    final certCount = context.watch<CertificateProvider>().certificatesList.length;
    final internshipCount = context.watch<InternshipProvider>().internshipsList.length;
    final courseCount = context.watch<CourseProvider>().coursesList.length;
    final eventCount = context.watch<EventProvider>().eventsList.length;

    final List<Map<String, dynamic>> sections = [
      {
        'title': 'Tech News',
        'count': newsCount,
        'icon': Icons.newspaper_rounded,
        'color': const Color(0xFF1A73E8),
        'route': AppRoutes.adminManageNews,
      },
      {
        'title': 'Roadmaps',
        'count': roadmapCount,
        'icon': Icons.alt_route_rounded,
        'color': Colors.deepPurple,
        'route': AppRoutes.adminManageRoadmaps,
      },
      {
        'title': 'Resources',
        'count': resourceCount,
        'icon': Icons.library_books_rounded,
        'color': Colors.orange,
        'route': AppRoutes.adminManageResources,
      },
      {
        'title': 'Certificates',
        'count': certCount,
        'icon': Icons.verified_rounded,
        'color': const Color(0xFF00BFA5),
        'route': AppRoutes.adminManageCertificates,
      },
      {
        'title': 'Internships',
        'count': internshipCount,
        'icon': Icons.work_rounded,
        'color': Colors.blue,
        'route': AppRoutes.adminManageInternships,
      },
      {
        'title': 'Courses',
        'count': courseCount,
        'icon': Icons.play_lesson_rounded,
        'color': Colors.pink,
        'route': AppRoutes.adminManageCourses,
      },
      {
        'title': 'Events & Hacks',
        'count': eventCount,
        'icon': Icons.emoji_events_rounded,
        'color': Colors.amber.shade800,
        'route': AppRoutes.adminManageEvents,
      },
      {
        'title': 'Notifications',
        'count': 'Push',
        'icon': Icons.notifications_active_rounded,
        'color': Colors.redAccent,
        'route': AppRoutes.adminSendNotifications,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel 🛡️'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin greeting card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield_rounded, color: Colors.amber, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'Content Control Center',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create, edit, and manage all learning roadmaps, news, opportunities, and push alerts for students.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Manage Content',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemCount: sections.length,
              itemBuilder: (context, idx) {
                final s = sections[idx];
                final Color color = s['color'];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () => context.push(s['route']),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(s['icon'], color: color, size: 24),
                              ),
                              Text(
                                '${s['count']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            s['title'],
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                'Manage',
                                style: TextStyle(fontSize: 11, color: theme.hintColor),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 12, color: theme.hintColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
