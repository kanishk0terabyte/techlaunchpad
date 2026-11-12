import 'package:flutter/foundation.dart';
import '../models/certificate_model.dart';
import '../services/firestore_service.dart';
import '../utils/mock_data.dart';

class CertificateProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<CertificateModel> _certificatesList = MockData.sampleCertificates;
  List<CertificateModel> _filteredCertificates = [];
  bool _isLoading = false;
  String _selectedPlatform = 'All';
  String _selectedSkill = 'All';

  List<CertificateModel> get certificatesList =>
      (_selectedPlatform == 'All' && _selectedSkill == 'All')
          ? _certificatesList
          : _filteredCertificates;
  bool get isLoading => _isLoading;
  String get selectedPlatform => _selectedPlatform;
  String get selectedSkill => _selectedSkill;

  void fetchCertificates() {
    _isLoading = true;
    notifyListeners();
    try {
      _firestoreService.getCertificatesStream().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _certificatesList = snapshot.docs
              .map((doc) => CertificateModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();
        } else {
          _certificatesList = MockData.sampleCertificates;
        }
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      }, onError: (_) {
        _certificatesList = MockData.sampleCertificates;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      });
    } catch (_) {
      _certificatesList = MockData.sampleCertificates;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByPlatform(String platform) {
    _selectedPlatform = platform;
    _applyFilters();
    notifyListeners();
  }

  void filterBySkill(String skill) {
    _selectedSkill = skill;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredCertificates = _certificatesList.where((c) {
      final matchPlatform = _selectedPlatform == 'All' || c.platform.toLowerCase() == _selectedPlatform.toLowerCase();
      final matchSkill = _selectedSkill == 'All' || c.skill.toLowerCase().contains(_selectedSkill.toLowerCase());
      return matchPlatform && matchSkill;
    }).toList();
  }
}
