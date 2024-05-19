import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medicare_reminder/models/alarm.dart';
import 'package:flutter_medicare_reminder/models/user.dart';

class DependentService {
  String userId;
  DependentService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerDependent(UserModel userModel) async {
    await _firestore
        .collection(userId)
        .doc(userModel.id)
        .set(userModel.toMap());
  }

  Future<void> registerAlarm(String idDependent, AlarmModel alarmModel) async {
    await _firestore
        .collection(userId)
        .doc(idDependent)
        .collection('alarmes')
        .doc(alarmModel.id)
        .set(alarmModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamDependent() {
    return _firestore.collection(userId).orderBy('name').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamAlarm(
      String idDependent) {
    return _firestore
        .collection(userId)
      .doc(idDependent)
      .collection('alarmes')
      .orderBy('hour')
      .snapshots();
  }

  Future<void> deleteDependent({required String dependentId}) {
    return _firestore.collection(userId).doc(dependentId).delete();
  }

  Future<void> deleteAlarm({required String dependentId, required String alarmId}) {
    return _firestore.collection(userId).doc(dependentId).collection('alarmes').doc(alarmId).delete();
  }
}
