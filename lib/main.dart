import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/news_provider.dart';
import 'providers/roadmap_provider.dart';
import 'providers/resource_provider.dart';
import 'providers/certificate_provider.dart';
import 'providers/internship_provider.dart';
import 'providers/course_provider.dart';
import 'providers/event_provider.dart';
import 'providers/bookmark_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init notice: $e');
  }
  runApp(const TechLaunchpadApp());
}

class TechLaunchpadApp extends StatelessWidget {
  const TechLaunchpadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()..fetchNews()),
        ChangeNotifierProvider(create: (_) => RoadmapProvider()..fetchRoadmaps()),
        ChangeNotifierProvider(create: (_) => ResourceProvider()..fetchResources()),
        ChangeNotifierProvider(create: (_) => CertificateProvider()..fetchCertificates()),
        ChangeNotifierProvider(create: (_) => InternshipProvider()..fetchInternships()),
        ChangeNotifierProvider(create: (_) => CourseProvider()..fetchCourses()),
        ChangeNotifierProvider(create: (_) => EventProvider()..fetchEvents()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'TechLaunchpad',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: AppRoutes.router,
          );
        },
      ),
    );
  }
}
