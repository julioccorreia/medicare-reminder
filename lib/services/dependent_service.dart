import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medicare_reminder/models/user.dart';

class DependentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> loginDependent(
      String email, String password) async {
    Query<Map<String, dynamic>> dependentsCollection =
        _firestore.collectionGroup('dependents');

    QuerySnapshot querySnapshot = await dependentsCollection.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['email'] == email && data['password'] == password) {
        String idParent = doc.reference.parent.parent!.id;
        UserModel userModel = UserModel(id: doc.id, name: data['name'], email: data['email'], password: data['password']);
        return {'valid': true, 'user': userModel, 'idParent': idParent};
      }
    }

    return {'valid': false};
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamAlarm(
      String idDependent, String idParent) {
    return _firestore
        .collection('users')
        .doc(idParent)
        .collection('dependents')
        .doc(idDependent)
        .collection('alarmes')
        .orderBy('hour')
        .snapshots();
  }
}
