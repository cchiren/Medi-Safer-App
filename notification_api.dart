import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification_vo.dart';

class NotificationApi {
  static final CollectionReference _ref = FirebaseFirestore.instance.collection('notifications');

  static Future<List<NotificationVo>> getList({
    String? userId,
    bool? isRead,
  }) async {
    Query query = _ref.orderBy('createDt', descending: true);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    if (isRead != null) {
      query = query.where('isRead', isEqualTo: isRead);
    }

    QuerySnapshot querySnapshot = await query.get();
    List<NotificationVo> itemList = List<NotificationVo>.from(querySnapshot.docs.map((e) => NotificationVo.fromQueryDocumentSnapshot(e)));

    return itemList;
  }

  static Stream<QuerySnapshot> getStream({
    String? userId,
    String? data,
    bool? isRead,
  }) {
    Query query = _ref.orderBy('createDt', descending: true);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    if (data != null) {
      query = query.where('data', isEqualTo: data);
    }

    if (isRead != null) {
      query = query.where('isRead', isEqualTo: isRead);
    }

    return query.snapshots();
  }

  static Future<NotificationVo> createOrUpdate(NotificationVo vo) async {
    if (vo.id.isEmpty) {
      DocumentReference res = await _ref.add(vo.toData());
      return NotificationVo.fromQueryDocumentSnapshot(await res.get());
    } else {
      await _ref.doc(vo.id).update(vo.toData());
      DocumentSnapshot snapshot = await _ref.doc(vo.id).get();
      return NotificationVo.fromQueryDocumentSnapshot(snapshot);
    }
  }

  static Future<void> delete(String id) async {
    await _ref.doc(id).delete();
  }
}