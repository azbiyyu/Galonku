// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseCrud {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String collectionName; // Nama koleksi dalam Firebase

//   FirebaseCrud(this.collectionName);

//   Future<void> addDocument(Map<String, dynamic> data) async {
//     try {
//       await _firestore.collection(collectionName).add(data);
//     } catch (e) {
//       print('Error adding document: $e');
//     }
//   }

//   Future<void> updateDocument(String documentId, Map<String, dynamic> data) async {
//     try {
//       await _firestore.collection(collectionName).doc(documentId).update(data);
//     } catch (e) {
//       print('Error updating document: $e');
//     }
//   }

//   Future<void> deleteDocument(String documentId) async {
//     try {
//       await _firestore.collection(collectionName).doc(documentId).delete();
//     } catch (e) {
//       print('Error deleting document: $e');
//     }
//   }

//   Future<List<Map<String, dynamic>>> getDocuments() async {
//     List<Map<String, dynamic>> documents = [];

//     try {
//       QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection(collectionName).get();

//       querySnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
//         documents.add(document.data());
//       });
//     } catch (e) {
//       print('Error getting documents: $e');
//     }

//     return documents;
//   }
// }
