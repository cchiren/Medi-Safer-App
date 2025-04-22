import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/medicine_vo.dart';

class MedicineApi {
  static final CollectionReference _ref = FirebaseFirestore.instance.collection('medicines');

  static Future<List<MedicineVo>> getList({
    String? userId,
  }) async {
    Query query = _ref.orderBy('createDt', descending: true);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    QuerySnapshot querySnapshot = await query.get();
    List<MedicineVo> itemList = List<MedicineVo>.from(querySnapshot.docs.map((e) => MedicineVo.fromQueryDocumentSnapshot(e)));

    return itemList;
  }

  static Future<MedicineVo?> get(String id) async {
    DocumentSnapshot documentSnapshot = await _ref.doc(id).get();
    if (documentSnapshot.exists) {
      MedicineVo vo = MedicineVo.fromQueryDocumentSnapshot(documentSnapshot);
      return vo;
    } else {
      return null;
    }
  }

  static Future<MedicineVo?> getByQrCode(String qrCode) async {
    Query query = _ref
        .where('qrCode', isEqualTo: qrCode)
        .orderBy('createDt', descending: true);
    QuerySnapshot querySnapshot = await query.get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    if (docs.isNotEmpty) {
      return MedicineVo.fromQueryDocumentSnapshot(docs.first);
    }
    return null;
  }

  static Future<MedicineVo> createOrUpdate(MedicineVo vo) async {
    if (vo.id.isEmpty) {
      DocumentReference res = await _ref.add(vo.toData());
      return MedicineVo.fromQueryDocumentSnapshot(await res.get());
    } else {
      await _ref.doc(vo.id).update(vo.toData());
      DocumentSnapshot snapshot = await _ref.doc(vo.id).get();
      return MedicineVo.fromQueryDocumentSnapshot(snapshot);
    }
  }

  static Future<void> delete(String id) async {
    await _ref.doc(id).delete();
  }

  static Stream<QuerySnapshot> getStream({
    String? userId,
  }) {
    Query query = _ref.orderBy('createDt', descending: true);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.snapshots();
  }
}