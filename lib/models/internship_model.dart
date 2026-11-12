import 'package:cloud_firestore/cloud_firestore.dart';

class InternshipModel {
  final String id;
  final String company;
  final String role;
  final String description;
  final String stipend;
  final String duration;
  final String location;
  final String type; // Remote, Onsite, Hybrid
  final List<String> skills;
  final String applyLink;
  final DateTime deadline;
  final DateTime createdAt;
  final bool isActive;

  const InternshipModel({
    required this.id,
    required this.company,
    required this.role,
    this.description = '',
    this.stipend = '',
    this.duration = '',
    this.location = '',
    this.type = 'Remote',
    this.skills = const [],
    required this.applyLink,
    required this.deadline,
    required this.createdAt,
    this.isActive = true,
  });

  factory InternshipModel.fromMap(Map<String, dynamic> map, String id) {
    return InternshipModel(
      id: id,
      company: map['company'] ?? '',
      role: map['role'] ?? '',
      description: map['description'] ?? '',
      stipend: map['stipend'] ?? '',
      duration: map['duration'] ?? '',
      location: map['location'] ?? '',
      type: map['type'] ?? 'Remote',
      skills: List<String>.from(map['skills'] ?? []),
      applyLink: map['applyLink'] ?? '',
      deadline: (map['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'role': role,
      'description': description,
      'stipend': stipend,
      'duration': duration,
      'location': location,
      'type': type,
      'skills': skills,
      'applyLink': applyLink,
      'deadline': Timestamp.fromDate(deadline),
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }
}
