import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateModel {
  final String id;
  final String title;
  final String platform;
  final String link;
  final String imageUrl;
  final String skill;
  final String duration;
  final String difficulty;
  final bool isFree;
  final DateTime createdAt;

  const CertificateModel({
    required this.id,
    required this.title,
    this.platform = '',
    required this.link,
    this.imageUrl = '',
    this.skill = '',
    this.duration = '',
    this.difficulty = 'Beginner',
    this.isFree = true,
    required this.createdAt,
  });

  factory CertificateModel.fromMap(Map<String, dynamic> map, String id) {
    return CertificateModel(
      id: id,
      title: map['title'] ?? '',
      platform: map['platform'] ?? '',
      link: map['link'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      skill: map['skill'] ?? '',
      duration: map['duration'] ?? '',
      difficulty: map['difficulty'] ?? 'Beginner',
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
      'skill': skill,
      'duration': duration,
      'difficulty': difficulty,
      'isFree': isFree,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
