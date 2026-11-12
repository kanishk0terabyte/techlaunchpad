import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String category;
  final List<String> tags;
  final DateTime createdAt;
  final int likes;
  final int views;

  const NewsModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl = '',
    this.category = 'General',
    this.tags = const [],
    required this.createdAt,
    this.likes = 0,
    this.views = 0,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map, String id) {
    return NewsModel(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? 'General',
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: map['likes'] ?? 0,
      views: map['views'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'category': category,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'views': views,
    };
  }
}
