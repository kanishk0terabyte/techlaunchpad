import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/news_provider.dart';
import '../../providers/certificate_provider.dart';
import '../../providers/internship_provider.dart';
import '../../config/routes.dart';
import '../../widgets/news_card.dart';
import '../../widgets/certificate_card.dart';
import '../../widgets/internship_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final newsProvider = context.watch<NewsProvider>();
    final certProvider = context.watch<CertificateProvider>();
    final internshipProvider = context.watch<InternshipProvider>();

    final userName = auth.user?.displayName ?? 'Engineer';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A73E8), Color(0xFF00BFA5)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('TechLaunchpad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded),
            onPressed: () => context.push(AppRoutes.bookmarks),
          ),
          if (auth.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_rounded, color: Colors.amber),
              onPressed: () => context.push(AppRoutes.adminDashboard),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<NewsProvider>().fetchNews();
          context.read<CertificateProvider>().fetchCertificates();
          context.read<InternshipProvider>().fetchInternships();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Welcome Banner
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1A73E8).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, $userName! 👋',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Level up your tech career today.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Quick Categories Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Quick Access',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildQuickTile(
                      context,
                      title: 'Roadmaps',
                      icon: Icons.alt_route_rounded,
                      color: const Color(0xFF1A73E8),
                      route: AppRoutes.roadmaps,
                    ),
                    const SizedBox(width: 10),
                    _buildQuickTile(
                      context,
                      title: 'Free Certs',
                      icon: Icons.verified_rounded,
                      color: const Color(0xFF00BFA5),
                      route: AppRoutes.certificates,
                    ),
                    const SizedBox(width: 10),
                    _buildQuickTile(
                      context,
                      title: 'Internships',
                      icon: Icons.work_rounded,
                      color: Colors.deepPurple,
                      route: AppRoutes.internships,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildQuickTile(
                      context,
                      title: 'Resources',
                      icon: Icons.menu_book_rounded,
                      color: Colors.orange,
                      route: AppRoutes.resources,
                    ),
                    const SizedBox(width: 10),
                    _buildQuickTile(
                      context,
                      title: 'Courses',
                      icon: Icons.play_lesson_rounded,
                      color: Colors.pink,
                      route: AppRoutes.courses,
                    ),
                    const SizedBox(width: 10),
                    _buildQuickTile(
                      context,
                      title: 'Tools & IDEs',
                      icon: Icons.build_circle_rounded,
                      color: Colors.teal,
                      route: AppRoutes.tools,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Latest Tech News Section
              _buildSectionHeader(
                context,
                title: '⚡ Latest Tech Updates',
                onSeeAll: () => context.push(AppRoutes.news),
              ),
              const SizedBox(height: 8),
              if (newsProvider.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
              else if (newsProvider.newsList.isEmpty)
                _buildEmptyState('No news articles yet')
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newsProvider.newsList.take(3).length,
                  itemBuilder: (context, idx) {
                    final item = newsProvider.newsList[idx];
                    return NewsCard(
                      news: item,
                      onTap: () => context.push('/news/${item.id}'),
                    );
                  },
                ),

              const SizedBox(height: 20),

              // Free Certifications Section
              _buildSectionHeader(
                context,
                title: '🎓 Free Certifications',
                onSeeAll: () => context.push(AppRoutes.certificates),
              ),
              const SizedBox(height: 8),
              if (certProvider.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
              else if (certProvider.certificatesList.isEmpty)
                _buildEmptyState('No certificates available')
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: certProvider.certificatesList.take(3).length,
                  itemBuilder: (context, idx) {
                    final item = certProvider.certificatesList[idx];
                    return CertificateCard(certificate: item);
                  },
                ),

              const SizedBox(height: 20),

              // Internships Section
              _buildSectionHeader(
                context,
                title: '💼 Featured Opportunities',
                onSeeAll: () => context.push(AppRoutes.internships),
              ),
              const SizedBox(height: 8),
              if (internshipProvider.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
              else if (internshipProvider.internshipsList.isEmpty)
                _buildEmptyState('No internship opportunities right now')
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: internshipProvider.internshipsList.take(3).length,
                  itemBuilder: (context, idx) {
                    final item = internshipProvider.internshipsList[idx];
                    return InternshipCard(internship: item);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, required VoidCallback onSeeAll}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See All →', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String msg) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(msg, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
