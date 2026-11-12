import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String title;
  final String platform;
  final String link;
  final String imageUrl;
  final String category;
  final String price;
  final double rating;
  final String duration;
  final bool isFree;
  final DateTime createdAt;

  const CourseModel({
    required this.id,
    required this.title,
    this.platform = '',
    required this.link,
    this.imageUrl = '',
    this.category = 'General',
    this.price = 'Free',
    this.rating = 0.0,
    this.duration = '',
    this.isFree = true,
    required this.createdAt,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map, String id) {
    return CourseModel(
      id: id,
      title: map['title'] ?? '',
      platform: map['platform'] ?? '',
      link: map['link'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? 'General',
      price: map['price'] ?? 'Free',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      duration: map['duration'] ?? '',
      isFree: map['isFree'] ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'platform': platform,
      'link': link,
      'imageUrl': imageUrl,
      'category': category,
      'price': price,
      'rating': rating,
      'duration': duration,
      'isFree': isFree,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
