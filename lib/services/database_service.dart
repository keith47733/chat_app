import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService(this.uid);

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');

  Future saveUserData(
    String name,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'user_name': name,
      'user_email': email,
      'groups': [],
      'user_image': '',
    });
  }

	Future getUserData(String email) async {
		QuerySnapshot snapshot = await userCollection
		.where('user_email', isEqualTo: email).get();
		return snapshot;
	}
}
