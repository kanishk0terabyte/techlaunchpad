import 'package:flutter/foundation.dart';
import '../models/news_model.dart';
import '../services/firestore_service.dart';
import '../utils/mock_data.dart';

class NewsProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<NewsModel> _newsList = MockData.sampleNews;
  List<NewsModel> _filteredNews = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<NewsModel> get newsList => _filteredNews.isEmpty && _searchQuery.isEmpty && _selectedCategory == 'All'
      ? _newsList
      : _filteredNews;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  void fetchNews() {
    _isLoading = true;
    notifyListeners();
    try {
      _firestoreService.getNewsStream().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _newsList = snapshot.docs
              .map((doc) => NewsModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();
        } else {
          _newsList = MockData.sampleNews;
        }
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      }, onError: (_) {
        _newsList = MockData.sampleNews;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      });
    } catch (_) {
      _newsList = MockData.sampleNews;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void searchNews(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredNews = _newsList.where((news) {
      final matchesCategory = _selectedCategory == 'All' || news.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          news.title.toLowerCase().contains(_searchQuery) ||
          news.content.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }
}
