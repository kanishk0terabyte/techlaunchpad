import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Generic CRUD ──────────────────────────────────────────────────────

  Stream<QuerySnapshot> getCollection(
    String path, {
    String? orderBy,
    bool descending = true,
    int? limit,
    List<List<dynamic>>? whereConditions,
  }) {
    Query query = _db.collection(path);
    if (whereConditions != null) {
      for (final c in whereConditions) {
        query = query.where(c[0] as String, isEqualTo: c.length > 1 ? c[1] : null);
      }
    }
    if (orderBy != null) query = query.orderBy(orderBy, descending: descending);
    if (limit != null) query = query.limit(limit);
    return query.snapshots();
  }

  Future<DocumentSnapshot> getDocument(String path) {
    return _db.doc(path).get();
  }

  Future<DocumentReference> addDocument(String path, Map<String, dynamic> data) {
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    return _db.collection(path).add(data);
  }

  Future<void> setDocument(String path, Map<String, dynamic> data, {bool merge = true}) {
    data['updatedAt'] = FieldValue.serverTimestamp();
    return _db.doc(path).set(data, SetOptions(merge: merge));
  }

  Future<void> updateDocument(String path, Map<String, dynamic> data) {
    data['updatedAt'] = FieldValue.serverTimestamp();
    return _db.doc(path).update(data);
  }

  Future<void> deleteDocument(String path) {
    return _db.doc(path).delete();
  }

  // ── Typed Streams ─────────────────────────────────────────────────────

  Stream<QuerySnapshot> _orderedStream(String col, {String orderBy = 'createdAt', int? limit}) =>
      getCollection(col, orderBy: orderBy, descending: true, limit: limit);

  Stream<QuerySnapshot> getNewsStream({int? limit}) => _orderedStream('news', orderBy: 'publishedAt', limit: limit);
  Stream<QuerySnapshot> getRoadmapsStream({int? limit}) => _orderedStream('roadmaps', limit: limit);
  Stream<QuerySnapshot> getResourcesStream({int? limit}) => _orderedStream('resources', limit: limit);
  Stream<QuerySnapshot> getCertificatesStream({int? limit}) => _orderedStream('certificates', limit: limit);
  Stream<QuerySnapshot> getInternshipsStream({int? limit}) => _orderedStream('internships', limit: limit);
  Stream<QuerySnapshot> getCoursesStream({int? limit}) => _orderedStream('courses', limit: limit);
  Stream<QuerySnapshot> getEventsStream({int? limit}) => _orderedStream('events', orderBy: 'date', limit: limit);
  Stream<QuerySnapshot> getToolsStream({int? limit}) => _orderedStream('tools', limit: limit);

  // ── User ──────────────────────────────────────────────────────────────

  Future<DocumentSnapshot> getUserData(String uid) => getDocument('users/$uid');

  Future<void> updateUserData(String uid, Map<String, dynamic> data) =>
      setDocument('users/$uid', data);

  Future<void> updateRoadmapProgress(String uid, String roadmapId, Map<String, dynamic> progress) =>
      setDocument('users/$uid/roadmapProgress/$roadmapId', progress);

  Stream<DocumentSnapshot> getUserRoadmapProgress(String uid, String roadmapId) =>
      _db.doc('users/$uid/roadmapProgress/$roadmapId').snapshots();

  // ── Search ────────────────────────────────────────────────────────────

  Future<QuerySnapshot> searchCollection(String collection, String field, String query) {
    final end = '$query\uf8ff';
    return _db
        .collection(collection)
        .where(field, isGreaterThanOrEqualTo: query)
        .where(field, isLessThanOrEqualTo: end)
        .limit(20)
        .get();
  }

  Future<List<QuerySnapshot>> globalSearch(String query) async {
    final lowerQuery = query.toLowerCase();
    final collections = ['news', 'roadmaps', 'resources', 'certificates', 'internships', 'courses', 'events', 'tools'];
    return Future.wait(
      collections.map((c) => searchCollection(c, 'searchTitle', lowerQuery)),
    );
  }

  // ── Bookmarks ─────────────────────────────────────────────────────────

  Future<void> toggleBookmark(String uid, String itemId, String collection) async {
    final ref = _db.doc('users/$uid/bookmarks/$itemId');
    final doc = await ref.get();
    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set({
        'itemId': itemId,
        'collection': collection,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<QuerySnapshot> getBookmarks(String uid) =>
      _db.collection('users/$uid/bookmarks').orderBy('createdAt', descending: true).snapshots();

  Future<bool> isBookmarked(String uid, String itemId) async {
    final doc = await _db.doc('users/$uid/bookmarks/$itemId').get();
    return doc.exists;
  }

  // ── Engagement ────────────────────────────────────────────────────────

  Future<void> incrementViews(String collection, String docId) =>
      _db.doc('$collection/$docId').update({'views': FieldValue.increment(1)});

  Future<void> toggleLike(String collection, String docId, String uid) async {
    final ref = _db.doc('$collection/$docId');
    final likesRef = ref.collection('likes').doc(uid);
    final likeDoc = await likesRef.get();

    final batch = _db.batch();
    if (likeDoc.exists) {
      batch.delete(likesRef);
      batch.update(ref, {'likes': FieldValue.increment(-1)});
    } else {
      batch.set(likesRef, {'createdAt': FieldValue.serverTimestamp()});
      batch.update(ref, {'likes': FieldValue.increment(1)});
    }
    await batch.commit();
  }
}
