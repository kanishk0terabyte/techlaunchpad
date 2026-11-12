import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../services/firestore_service.dart';

class EventProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<EventModel> _eventsList = [];
  List<EventModel> _filteredEvents = [];
  bool _isLoading = false;
  String _selectedType = 'All';

  List<EventModel> get eventsList =>
      _selectedType == 'All' ? _eventsList : _filteredEvents;
  bool get isLoading => _isLoading;
  String get selectedType => _selectedType;

  void fetchEvents() {
    _isLoading = true;
    notifyListeners();
    _firestoreService.getEventsStream().listen((snapshot) {
      _eventsList = snapshot.docs
          .map((doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    });
  }

  void filterByType(String type) {
    _selectedType = type;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_selectedType == 'All') {
      _filteredEvents = _eventsList;
    } else {
      _filteredEvents = _eventsList
          .where((e) => e.type.toLowerCase() == _selectedType.toLowerCase())
          .toList();
    }
  }
}
