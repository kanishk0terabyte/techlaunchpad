import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:techlaunchpad/models/resource_model.dart';
import 'package:techlaunchpad/services/firestore_service.dart';

class ResourceProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ResourceModel> _resourcesList = [];
  List<ResourceModel> _filteredResources = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _selectedType = 'All';
  String _selectedDifficulty = 'All';

  List<ResourceModel> get resourcesList =>
      (_selectedCategory == 'All' && _selectedType == 'All' && _selectedDifficulty == 'All')
          ? _resourcesList
          : _filteredResources;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get selectedType => _selectedType;
  String get selectedDifficulty => _selectedDifficulty;

  void fetchResources() {
    _isLoading = true;
    notifyListeners();
    _firestoreService.getResourcesStream().listen((snapshot) {
      _resourcesList = snapshot.docs
          .map((doc) => ResourceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    });
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void filterByType(String type) {
    _selectedType = type;
    _applyFilters();
    notifyListeners();
  }

  void filterByDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredResources = _resourcesList.where((r) {
      final matchCat = _selectedCategory == 'All' || r.category == _selectedCategory;
      final matchType = _selectedType == 'All' || r.type == _selectedType;
      final matchDiff = _selectedDifficulty == 'All' || r.difficulty == _selectedDifficulty;
      return matchCat && matchType && matchDiff;
    }).toList();
  }
}
