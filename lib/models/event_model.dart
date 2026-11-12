import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final String link;
  final String imageUrl;
  final DateTime date;
  final DateTime endDate;
  final String prizes;
  final String eligibility;
  final String type; // Hackathon, Contest, Workshop, Webinar
  final DateTime createdAt;

  const EventModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.link,
    this.imageUrl = '',
    required this.date,
    required this.endDate,
    this.prizes = '',
    this.eligibility = '',
    this.type = 'Hackathon',
    required this.createdAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> map, String id) {
    return EventModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      link: map['link'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (map['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      prizes: map['prizes'] ?? '',
      eligibility: map['eligibility'] ?? '',
      type: map['type'] ?? 'Hackathon',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'imageUrl': imageUrl,
      'date': Timestamp.fromDate(date),
      'endDate': Timestamp.fromDate(endDate),
      'prizes': prizes,
      'eligibility': eligibility,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
