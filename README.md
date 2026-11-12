# 🚀 TechLaunchpad - Engineering Career & Learning Super-App

An all-in-one Flutter application designed for engineering students and aspiring developers to accelerate their tech careers with curated roadmaps, free certifications, internships, daily tech news, and an integrated Admin CMS.

---

## 📱 Features

### 👨‍🎓 For Students
- **⚡ Daily Tech News**: Real-time updates across AI/ML, Web, Mobile, Cloud, DevOps, and Cyber Security.
- **🗺️ Interactive Skill Roadmaps**: Step-by-step milestone checklists for Full-Stack, AI/ML, Mobile, and more with progress calculation.
- **🎓 100% Free Certifications**: Curated free cert courses from Google, IBM, Microsoft, AWS, Coursera, HackerRank, and FreeCodeCamp.
- **💼 Internships & Job Opportunities**: Fresh opportunities with stipend info, required skills tags, and 1-click apply links.
- **📚 Resources Hub**: Filterable list of curated YouTube playlists, GitHub repos, technical documentation, and books.
- **📖 Curated Engineering Courses**: High-rated courses across engineering disciplines.
- **🏆 Hackathons & Contests**: Upcoming global & national hackathons with prize pools and dates.
- **🛠️ Developer Tools & IDEs**: Curated tools (VS Code, Git, Postman, Docker, Figma, Notion) with direct setup links.
- **🔖 Bookmarks & Dark Mode**: Save articles, jobs, and courses for offline reference with dynamic Material 3 Dark/Light themes.

### 🛡️ For Administrators (In-App CMS)
- **📊 Real-time Dashboard**: Live counters for total articles, roadmaps, opportunities, and resources.
- **✏️ Universal Content Manager**: Add, edit, and delete any content directly from the app using dynamic bottom-sheet forms.
- **📢 Push Notification Broadcast**: Send instant alert messages to all active student devices.

---

## 🏗️ Architecture & Tech Stack

```
lib/
├── config/             # Theme, GoRouter Routes, App Constants
├── models/             # 14 Strongly-typed Data Models
├── providers/          # 10 State Management Providers (Provider architecture)
├── screens/
│   ├── admin/          # Dashboard, Universal CMS, Push Notifications
│   ├── auth/           # Login, Signup, Guest Mode
│   ├── bookmarks/      # Saved Items Tab View
│   ├── certificates/   # Free Certifications Directory
│   ├── courses/        # Course Catalog
│   ├── events/         # Hackathons & Contests
│   ├── home/           # Dashboard & 5-tab Navigation Wrapper
│   ├── internships/    # Internships & Opportunities
│   ├── news/           # News Feed & Article Reader
│   ├── profile/        # Student Profile & Preferences
│   ├── resources/      # Developer Resources Hub
│   ├── roadmaps/       # Step-by-step Interactive Roadmaps
│   ├── splash/         # Animated Launch Screen
│   └── tools/          # Developer Software & IDEs
├── services/           # Firebase Auth, Firestore, Cloud Storage, Push Notifications
├── utils/              # Mock Data Fallback for instant offline testing
└── widgets/            # 16 Reusable Material 3 Cards & UI Components
```

---

## ⚡ How to Run & Build APK

### 1. Prerequisites
Ensure you have the Flutter SDK installed on your system.

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Connect Firebase (Optional for full backend persistence)
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com).
2. Enable **Authentication** (Email/Password & Google Sign-In).
3. Enable **Cloud Firestore** and **Firebase Storage**.
4. Download `google-services.json` and place it in:
   ```
   android/app/google-services.json
   ```

*Note: The app comes with built-in `MockData` fallback so it runs and displays full rich content immediately even before Firebase setup!*

### 4. Build Release APK
```bash
flutter build apk --release
```
The generated APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```
