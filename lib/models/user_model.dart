import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String branch;
  final String year;
  final String college;
  final List<String> skills;
  final List<String> bookmarks;
  final Map<String, double> roadmapProgress;
  final bool isAdmin;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl = '',
    this.branch = '',
    this.year = '',
    this.college = '',
    this.skills = const [],
    this.bookmarks = const [],
    this.roadmapProgress = const {},
    this.isAdmin = false,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      branch: map['branch'] ?? '',
      year: map['year'] ?? '',
      college: map['college'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      bookmarks: List<String>.from(map['bookmarks'] ?? []),
      roadmapProgress: Map<String, double>.from(
        (map['roadmapProgress'] ?? {}).map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
      isAdmin: map['isAdmin'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'branch': branch,
      'year': year,
      'college': college,
      'skills': skills,
      'bookmarks': bookmarks,
      'roadmapProgress': roadmapProgress,
      'isAdmin': isAdmin,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? branch,
    String? year,
    String? college,
    List<String>? skills,
    List<String>? bookmarks,
    Map<String, double>? roadmapProgress,
    bool? isAdmin,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      branch: branch ?? this.branch,
      year: year ?? this.year,
      college: college ?? this.college,
      skills: skills ?? this.skills,
      bookmarks: bookmarks ?? this.bookmarks,
      roadmapProgress: roadmapProgress ?? this.roadmapProgress,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
