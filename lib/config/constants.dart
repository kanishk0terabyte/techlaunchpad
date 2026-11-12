class AppConstants {
  static const String appName = 'TechLaunchpad';
  static const String appTagline = 'Your Tech Career Companion';
  static const String appVersion = '1.0.0';
  static const String appPackage = 'com.techlaunchpad.app';

  static const String firestoreUsers = 'users';
  static const String firestoreNews = 'news';
  static const String firestoreRoadmaps = 'roadmaps';
  static const String firestoreResources = 'resources';
  static const String firestoreCertificates = 'certificates';
  static const String firestoreInternships = 'internships';
  static const String firestoreCourses = 'courses';
  static const String firestoreEvents = 'events';
  static const String firestoreTools = 'tools';
  static const String firestoreNotifications = 'notifications';

  static const int paginationLimit = 15;
  static const int searchDebounceMs = 400;

  static const List<String> categories = [
    'Web Development',
    'Mobile Development',
    'Data Science',
    'Machine Learning',
    'Artificial Intelligence',
    'Cloud Computing',
    'DevOps',
    'Cybersecurity',
    'Blockchain',
    'IoT',
    'Game Development',
    'UI/UX Design',
    'Database',
    'Backend',
    'Frontend',
    'Full Stack',
    'Competitive Programming',
    'Open Source',
    'Career',
    'General',
  ];

  static const List<String> difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  static const List<String> branches = [
    'Computer Science',
    'Information Technology',
    'Electronics & Communication',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Biotechnology',
    'Aerospace Engineering',
    'Data Science',
    'Artificial Intelligence',
    'Other',
  ];

  static const List<String> resourceTypes = [
    'YouTube',
    'Website',
    'GitHub',
    'Book',
    'Blog',
  ];

  static const List<String> internshipTypes = [
    'Remote',
    'Onsite',
    'Hybrid',
  ];

  static const List<String> eventTypes = [
    'Hackathon',
    'Contest',
    'Workshop',
    'Webinar',
  ];

  static const List<String> years = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
    'Graduate',
  ];
}
