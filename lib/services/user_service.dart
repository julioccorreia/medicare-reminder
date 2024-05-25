import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medicare_reminder/models/alarm.dart';
import 'package:flutter_medicare_reminder/models/user.dart';

class UserService {
  String userId;
  UserService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registerDependent(UserModel userModel) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collectionGroup('dependents')
        .where('email', isEqualTo: userModel.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return 'O email já está sendo usado por outro dependente.';
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('dependents')
        .doc(userModel.id)
        .set(userModel.toMap());
    return null;
  }

  Future<void> registerAlarm(String idDependent, AlarmModel alarmModel) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('dependents')
        .doc(idDependent)
        .collection('alarmes')
        .doc(alarmModel.id)
        .set(alarmModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamDependent() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('dependents')
        .orderBy('name')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamAlarm(
      String idDependent) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('dependents')
        .doc(idDependent)
        .collection('alarmes')
        .orderBy('hour')
        .snapshots();
  }

  Future<void> deleteDependent({required String dependentId}) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('dependents')
        .doc(dependentId)
        .delete();
  }

  Future<void> deleteAlarm(
      {required String dependentId, required String alarmId}) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('dependents')
        .doc(dependentId)
        .collection('alarmes')
        .doc(alarmId)
        .delete();
  }
}
