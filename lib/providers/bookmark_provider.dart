import 'package:flutter/foundation.dart';
import 'package:techlaunchpad/services/firestore_service.dart';

class BookmarkProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  final Set<String> _bookmarkedIds = {};
  bool _isLoading = false;

  Set<String> get bookmarkedIds => _bookmarkedIds;
  bool get isLoading => _isLoading;

  bool isBookmarked(String id) => _bookmarkedIds.contains(id);

  void fetchBookmarks(String uid) {
    _isLoading = true;
    notifyListeners();
    _firestoreService.getBookmarks(uid).listen((snapshot) {
      _bookmarkedIds.clear();
      for (final doc in snapshot.docs) {
        _bookmarkedIds.add(doc.id);
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> toggleBookmark(String uid, String itemId, String collection) async {
    // Optimistic update
    if (_bookmarkedIds.contains(itemId)) {
      _bookmarkedIds.remove(itemId);
    } else {
      _bookmarkedIds.add(itemId);
    }
    notifyListeners();

    try {
      await _firestoreService.toggleBookmark(uid, itemId, collection);
    } catch (e) {
      // Revert on error
      if (_bookmarkedIds.contains(itemId)) {
        _bookmarkedIds.remove(itemId);
      } else {
        _bookmarkedIds.add(itemId);
      }
      notifyListeners();
    }
  }
}
