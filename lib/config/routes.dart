import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/main_wrapper.dart';
import '../screens/news/news_list_screen.dart';
import '../screens/news/news_detail_screen.dart';
import '../screens/roadmaps/roadmap_list_screen.dart';
import '../screens/roadmaps/roadmap_detail_screen.dart';
import '../screens/resources/resource_list_screen.dart';
import '../screens/certificates/certificate_list_screen.dart';
import '../screens/internships/internship_list_screen.dart';
import '../screens/courses/course_list_screen.dart';
import '../screens/events/event_list_screen.dart';
import '../screens/tools/tools_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/bookmarks/bookmarks_screen.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/admin_manage_items_screen.dart';
import '../screens/admin/send_notification_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const news = '/news';
  static const newsDetail = '/news/:id';
  static const roadmaps = '/roadmaps';
  static const roadmapDetail = '/roadmaps/:id';
  static const resources = '/resources';
  static const certificates = '/certificates';
  static const internships = '/internships';
  static const courses = '/courses';
  static const events = '/events';
  static const tools = '/tools';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const bookmarks = '/bookmarks';
  static const adminDashboard = '/admin';
  static const adminManageNews = '/admin/news';
  static const adminManageRoadmaps = '/admin/roadmaps';
  static const adminManageResources = '/admin/resources';
  static const adminManageCertificates = '/admin/certificates';
  static const adminManageInternships = '/admin/internships';
  static const adminManageCourses = '/admin/courses';
  static const adminManageEvents = '/admin/events';
  static const adminSendNotifications = '/admin/notifications';

  static final router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(path: splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: signup, builder: (_, __) => const SignupScreen()),
      GoRoute(path: home, builder: (_, __) => const MainWrapper(initialIndex: 0)),
      GoRoute(path: news, builder: (_, __) => const NewsListScreen()),
      GoRoute(
        path: newsDetail,
        builder: (_, state) => NewsDetailScreen(newsId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(path: roadmaps, builder: (_, __) => const MainWrapper(initialIndex: 1)),
      GoRoute(
        path: roadmapDetail,
        builder: (_, state) => RoadmapDetailScreen(roadmapId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(path: resources, builder: (_, __) => const MainWrapper(initialIndex: 2)),
      GoRoute(path: certificates, builder: (_, __) => const CertificateListScreen()),
      GoRoute(path: internships, builder: (_, __) => const MainWrapper(initialIndex: 3)),
      GoRoute(path: courses, builder: (_, __) => const CourseListScreen()),
      GoRoute(path: events, builder: (_, __) => const EventListScreen()),
      GoRoute(path: tools, builder: (_, __) => const ToolsScreen()),
      GoRoute(path: profile, builder: (_, __) => const MainWrapper(initialIndex: 4)),
      GoRoute(path: editProfile, builder: (_, __) => const EditProfileScreen()),
      GoRoute(path: bookmarks, builder: (_, __) => const BookmarksScreen()),
      GoRoute(path: adminDashboard, builder: (_, __) => const AdminDashboard()),

      // Admin Management CRUD routes
      GoRoute(
        path: adminManageNews,
        builder: (_, __) => const AdminManageItemsScreen(
          title: 'News Article',
          collectionName: 'news',
          fields: [
            FieldConfig(key: 'title', label: 'Article Title'),
            FieldConfig(key: 'category', label: 'Category', options: ['AI & ML', 'Web Dev', 'Mobile Dev', 'Cloud', 'DevOps', 'Cyber Security']),
            FieldConfig(key: 'content', label: 'Content'),
            FieldConfig(key: 'imageUrl', label: 'Image URL'),
            FieldConfig(key: 'tags', label: 'Tags (comma-separated)'),
          ],
        ),
      ),
      GoRoute(
        path: adminManageRoadmaps,
        builder: (_, __) => const AdminManageItemsScreen(
          title: 'Roadmap',
          collectionName: 'roadmaps',
          fields: [
            FieldConfig(key: 'title', label: 'Roadmap Title'),
            FieldConfig(key: 'category', label: 'Category', options: ['Frontend', 'Backend', 'Full Stack', 'AI & ML', 'DevOps', 'Mobile', 'Cyber Security']),
            FieldConfig(key: 'description', label: 'Description'),
            FieldConfig(key: 'imageUrl', label: 'Image URL'),
          ],
        ),
      ),
      GoRoute(
        path: adminManageResources,
        builder: (_, __) => const AdminManageItemsScreen(
          title: 'Resource',
          collectionName: 'resources',
          fields: [
            FieldConfig(key: 'title', label: 'Resource Title'),
            FieldConfig(key: 'category', label: 'Category'),
            FieldConfig(key: 'type', label: 'Type', options: ['YouTube', 'Website', 'GitHub', 'Book', 'Blog']),
            FieldConfig(key: 'difficulty', label: 'Difficulty', options: ['Beginner', 'Intermediate', 'Advanced']),
            FieldConfig(key: 'link', label: 'Resource URL'),
            FieldConfig(key: 'description', label: 'Description'),
          ],
        ),
      ),
      GoRoute(
        path: adminManageCertificates,
        builder: (_, __) => const AdminManageItemsScreen(
          title: 'Certificate',
          collectionName: 'certificates',
          fields: [
            FieldConfig(key: 'title', label: 'Certificate Course Title'),
            FieldConfig(key: 'platform', label: 'Platform', options: ['Google', 'IBM', 'Coursera', 'Microsoft', 'AWS', 'FreeCodeCamp', 'HackerRank']),
            FieldConfig(key: 'skill', label: 'Skill Learned'),
            FieldConfig(key: 'duration', label: 'Estimated Duration'),
            FieldConfig(key: 'difficulty', label: 'Difficulty', options: ['Beginner', 'Intermediate', 'Advanced']),
            FieldConfig(key: 'link', label: 'Enrollment Link'),
            FieldConfig(key: 'imageUrl', label: 'Logo / Image URL'),
          ],
        ),
      ),
      GoRoute(
        path: adminManageInternships,
        builder: (_, __) => const AdminManageItemsScreen(
          title: 'Internship',
          collectionName: 'internships',
          fields: [
            FieldConfig(key: 'company', label: 'Company Name'),
            FieldConfig(key: 'role', label: 'Job / Internship Role'),
            FieldConfig(key: 'stipend', label: 'Stipend (e.g. ₹25,000/mo or Unpaid)'),
            FieldConfig(key: 'type', label: 'Work Mode', options: ['Remote', 'Onsite', 'Hybrid']),
            FieldConfig(key: 'location', label: 'Location'),
            FieldConfig(key: 'duration', label: 'Duration (e.g. 3 Months)'),
            FieldConfig(key: 'skills', label: 'Skills Required (comma-separated)'),
            FieldConfig(key: 'applyLink', label: 'Application Link'),
            FieldConfig(key: 'description', label: 'Job Description'),
          ],
        ),
      ),
      GoRoute(
        path: adminManageCourses,
        builder: (_, __) => const AdminManageItemsScreen(
          title: 'Course',
          collectionName: 'courses',
          fields: [
            FieldConfig(key: 'title', label: 'Course Title'),
            FieldConfig(key: 'platform', label: 'Platform'),
            FieldConfig(key: 'category', label: 'Category'),
            FieldConfig(key: 'price', label: 'Price (e.g. Free or ₹499)'),
            FieldConfig(key: 'duration', label: 'Duration'),
            FieldConfig(key: 'rating', label: 'Rating (e.g. 4.8)'),
            FieldConfig(key: 'link', label: 'Course Link'),
            FieldConfig(key: 'imageUrl', label: 'Thumbnail URL'),
          ],
        ),
      ),
      GoRoute(
        path: adminManageEvents,
        builder: (_, __) => const AdminManageItemsScreen(
          title: 'Event / Hackathon',
          collectionName: 'events',
          fields: [
            FieldConfig(key: 'title', label: 'Event Title'),
            FieldConfig(key: 'type', label: 'Type', options: ['Hackathon', 'Contest', 'Workshop', 'Webinar']),
            FieldConfig(key: 'prizes', label: 'Prizes (e.g. ₹1,00,000)'),
            FieldConfig(key: 'eligibility', label: 'Eligibility'),
            FieldConfig(key: 'link', label: 'Registration Link'),
            FieldConfig(key: 'description', label: 'Event Details'),
          ],
        ),
      ),
      GoRoute(path: adminSendNotifications, builder: (_, __) => const SendNotificationScreen()),
    ],
  );
}
