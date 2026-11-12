import 'package:cloud_firestore/cloud_firestore.dart';

class ToolModel {
  final String id;
  final String name;
  final String description;
  final String link;
  final String imageUrl;
  final String category;
  final String platform;
  final DateTime createdAt;

  const ToolModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.link,
    this.imageUrl = '',
    this.category = 'General',
    this.platform = 'Web',
    required this.createdAt,
  });

  factory ToolModel.fromMap(Map<String, dynamic> map, String id) {
    return ToolModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      link: map['link'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? 'General',
      platform: map['platform'] ?? 'Web',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'link': link,
      'imageUrl': imageUrl,
      'category': category,
      'platform': platform,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
