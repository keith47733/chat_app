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
    QuerySnapshot snapshot = await userCollection.where('user_email', isEqualTo: email).get();
    return snapshot;
  }

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  Future createGroup(
    String userName,
    String id,
    String groupName,
  ) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      'admin': "${id}_$userName",
      'group_id': '',
      'group_name': groupName,
      'group_icon': '',
      'members': [],
      'recent_message': '',
      'recent_message_sender': '',
    }); // CREATES ID WHEN DOC IS CREATED
    await groupDocumentReference.update({
      'group_id': groupDocumentReference.id, // UPDATE DOC WITH NEWLY CREATED ID ABOVE
      'members': FieldValue.arrayUnion(['${uid}_$userName']),
    });
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      'groups': FieldValue.arrayUnion(['${groupDocumentReference.id}_$groupName'])
    });
  }
}
