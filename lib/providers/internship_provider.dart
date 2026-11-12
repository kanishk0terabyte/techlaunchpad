import 'package:flutter/foundation.dart';
import '../models/internship_model.dart';
import '../services/firestore_service.dart';
import '../utils/mock_data.dart';

class InternshipProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<InternshipModel> _internshipsList = MockData.sampleInternships;
  List<InternshipModel> _filteredInternships = [];
  bool _isLoading = false;
  String _selectedType = 'All';
  String _selectedSkill = 'All';
  String _selectedLocation = 'All';

  List<InternshipModel> get internshipsList =>
      (_selectedType == 'All' && _selectedSkill == 'All' && _selectedLocation == 'All')
          ? _internshipsList
          : _filteredInternships;
  bool get isLoading => _isLoading;
  String get selectedType => _selectedType;
  String get selectedSkill => _selectedSkill;
  String get selectedLocation => _selectedLocation;

  void fetchInternships() {
    _isLoading = true;
    notifyListeners();
    try {
      _firestoreService.getInternshipsStream().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _internshipsList = snapshot.docs
              .map((doc) => InternshipModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();
        } else {
          _internshipsList = MockData.sampleInternships;
        }
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      }, onError: (_) {
        _internshipsList = MockData.sampleInternships;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      });
    } catch (_) {
      _internshipsList = MockData.sampleInternships;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByType(String type) {
    _selectedType = type;
    _applyFilters();
    notifyListeners();
  }

  void filterBySkill(String skill) {
    _selectedSkill = skill;
    _applyFilters();
    notifyListeners();
  }

  void filterByLocation(String location) {
    _selectedLocation = location;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredInternships = _internshipsList.where((i) {
      final matchType = _selectedType == 'All' || i.type.toLowerCase() == _selectedType.toLowerCase();
      final matchSkill = _selectedSkill == 'All' || i.skills.any((s) => s.toLowerCase().contains(_selectedSkill.toLowerCase()));
      final matchLocation = _selectedLocation == 'All' || i.location.toLowerCase().contains(_selectedLocation.toLowerCase());
      return matchType && matchSkill && matchLocation;
    }).toList();
  }
}
