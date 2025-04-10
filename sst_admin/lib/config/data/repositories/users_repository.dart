import 'package:cloud_firestore/cloud_firestore.dart';

class UsersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').snapshots();
  }
}
