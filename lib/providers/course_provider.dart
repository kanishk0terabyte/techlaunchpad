import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:techlaunchpad/models/course_model.dart';
import 'package:techlaunchpad/services/firestore_service.dart';

class CourseProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<CourseModel> _coursesList = [];
  List<CourseModel> _filteredCourses = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _selectedPrice = 'All';

  List<CourseModel> get coursesList =>
      (_selectedCategory == 'All' && _selectedPrice == 'All')
          ? _coursesList
          : _filteredCourses;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get selectedPrice => _selectedPrice;

  void fetchCourses() {
    _isLoading = true;
    notifyListeners();
    _firestoreService.getCoursesStream().listen((snapshot) {
      _coursesList = snapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
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

  void filterByPrice(String price) {
    _selectedPrice = price;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredCourses = _coursesList.where((c) {
      final matchCat = _selectedCategory == 'All' || c.category == _selectedCategory;
      final matchPrice = _selectedPrice == 'All' ||
          (_selectedPrice == 'Free' && c.isFree) ||
          (_selectedPrice == 'Paid' && !c.isFree);
      return matchCat && matchPrice;
    }).toList();
  }
}
