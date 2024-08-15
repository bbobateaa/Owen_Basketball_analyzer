import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateFirestoreDocument(userId) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'is_processing': true}, SetOptions(merge: true));
  } catch (e) {
    print('Error updating Firestore document: $e');
  }
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getData(userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots();
}