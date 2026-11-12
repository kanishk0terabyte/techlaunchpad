import 'package:flutter/foundation.dart';
import '../models/roadmap_model.dart';
import '../services/firestore_service.dart';
import '../utils/mock_data.dart';

class RoadmapProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<RoadmapModel> _roadmapsList = MockData.sampleRoadmaps;
  List<RoadmapModel> _filteredRoadmaps = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';

  List<RoadmapModel> get roadmapsList =>
      _selectedCategory == 'All' ? _roadmapsList : _filteredRoadmaps;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  void fetchRoadmaps() {
    _isLoading = true;
    notifyListeners();
    try {
      _firestoreService.getRoadmapsStream().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _roadmapsList = snapshot.docs
              .map((doc) => RoadmapModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();
        } else {
          _roadmapsList = MockData.sampleRoadmaps;
        }
        _applyFilter();
        _isLoading = false;
        notifyListeners();
      }, onError: (_) {
        _roadmapsList = MockData.sampleRoadmaps;
        _applyFilter();
        _isLoading = false;
        notifyListeners();
      });
    } catch (_) {
      _roadmapsList = MockData.sampleRoadmaps;
      _applyFilter();
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedCategory == 'All') {
      _filteredRoadmaps = _roadmapsList;
    } else {
      _filteredRoadmaps = _roadmapsList
          .where((r) => r.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }
  }
}
