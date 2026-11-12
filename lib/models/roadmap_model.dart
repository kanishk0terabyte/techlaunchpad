import 'package:cloud_firestore/cloud_firestore.dart';

class RoadmapStep {
  final String title;
  final String description;
  final List<String> resources;
  final String estimatedTime;

  const RoadmapStep({
    required this.title,
    this.description = '',
    this.resources = const [],
    this.estimatedTime = '',
  });

  factory RoadmapStep.fromMap(Map<String, dynamic> map) {
    return RoadmapStep(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      resources: List<String>.from(map['resources'] ?? []),
      estimatedTime: map['estimatedTime'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'resources': resources,
      'estimatedTime': estimatedTime,
    };
  }
}

class RoadmapModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final List<RoadmapStep> steps;
  final DateTime createdAt;

  const RoadmapModel({
    required this.id,
    required this.title,
    this.description = '',
    this.category = 'General',
    this.imageUrl = '',
    this.steps = const [],
    required this.createdAt,
  });

  factory RoadmapModel.fromMap(Map<String, dynamic> map, String id) {
    return RoadmapModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      imageUrl: map['imageUrl'] ?? '',
      steps: (map['steps'] as List<dynamic>?)
              ?.map((s) => RoadmapStep.fromMap(Map<String, dynamic>.from(s)))
              .toList() ??
          [],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'steps': steps.map((s) => s.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
