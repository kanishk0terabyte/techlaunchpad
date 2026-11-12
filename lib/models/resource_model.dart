import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceModel {
  final String id;
  final String title;
  final String description;
  final String link;
  final String imageUrl;
  final String category;
  final String type; // YouTube, Website, GitHub, Book, Blog
  final String difficulty;
  final String branch;
  final DateTime createdAt;

  const ResourceModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.link,
    this.imageUrl = '',
    this.category = 'General',
    this.type = 'Website',
    this.difficulty = 'Beginner',
    this.branch = 'Computer Science',
    required this.createdAt,
  });

  factory ResourceModel.fromMap(Map<String, dynamic> map, String id) {
    return ResourceModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      link: map['link'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? 'General',
      type: map['type'] ?? 'Website',
      difficulty: map['difficulty'] ?? 'Beginner',
      branch: map['branch'] ?? 'Computer Science',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'imageUrl': imageUrl,
      'category': category,
      'type': type,
      'difficulty': difficulty,
      'branch': branch,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
