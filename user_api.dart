import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_vo.dart';

class UserApi {
  static final CollectionReference _ref = FirebaseFirestore.instance.collection('users');

  static Future<UserVo?> getUser() async {
    DocumentSnapshot documentSnapshot = await _ref.doc(FirebaseAuth.instance.currentUser?.uid).get();
    if (documentSnapshot.exists) {
      UserVo userVo = UserVo.fromQueryDocumentSnapshot(documentSnapshot);
      return userVo;
    } else {
      return null;
    }
  }

  static Future<UserVo?> getUserById(String id) async {
    DocumentSnapshot documentSnapshot = await _ref.doc(id).get();
    if (documentSnapshot.exists) {
      return UserVo.fromQueryDocumentSnapshot(documentSnapshot);
    } else {
      return null;
    }
  }

  static Future<List<UserVo>> getUsers() async {
    Query query = _ref;
    QuerySnapshot querySnapshot = await query.get();
    List<UserVo> userVoList = List<UserVo>.from(querySnapshot.docs.map((e) => UserVo.fromQueryDocumentSnapshot(e)));
    return userVoList;
  }

  static Future<UserVo> update({
    required UserVo userVo,
  }) async {
    await _ref.doc(userVo.id).update(userVo.toData());
    return (await getUserById(userVo.id))!;
  }

  static Future<UserVo> updateByMapData({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _ref.doc(userId).update(data);
    return (await getUserById(userId))!;
  }

  static Future<UserVo> createOrUpdate(UserVo vo) async {
    if (vo.id.isEmpty) {
      DocumentReference res = await _ref.add(vo.toData());
      return UserVo.fromQueryDocumentSnapshot(await res.get());
    } else {
      await _ref.doc(vo.id).update(vo.toData());
      DocumentSnapshot snapshot = await _ref.doc(vo.id).get();
      return UserVo.fromQueryDocumentSnapshot(snapshot);
    }
  }
}