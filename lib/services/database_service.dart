import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

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

  getGroups() async {
    return groupCollection.snapshots();
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

  Future getGroupAdmin(String groupID) async {
    DocumentReference ref = groupCollection.doc(groupID);
    DocumentSnapshot doc = await ref.get();
    return doc['admin'];
  }

  getChats(String groupID) async {
    return groupCollection.doc(groupID).collection('messages').orderBy('time').snapshots();
  }

  getGroupMembers(String groupID) async {
    return groupCollection.doc(groupID).snapshots();
  }

  searchGroupsByName(String groupSearch) {
    return groupCollection.where('group_name', isEqualTo: groupSearch).get();
  }

  Future<bool> isUserInGroup(String groupID, String groupName, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot userDocumentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await userDocumentSnapshot['groups'];
    if (groups.contains('${groupID}_$groupName')) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoin(String groupID, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupID);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if (groups.contains('${groupID}_$groupName')) {
      await userDocumentReference.update({
        'groups': FieldValue.arrayRemove(['${groupID}_$groupName'])
      });
      await groupDocumentReference.update({
        'members': FieldValue.arrayRemove(['${uid}_$userName'])
      });
    } else {
      await userDocumentReference.update({
        'groups': FieldValue.arrayUnion(['${groupID}_$groupName'])
      });
      await groupDocumentReference.update({
        'members': FieldValue.arrayUnion(['${uid}_$userName'])
      });
    }
  }

  sendMessage(
    String groupID,
    Map<String, dynamic> chatMessageData,
  ) {
    groupCollection.doc(groupID).collection('messages').add(chatMessageData);
    groupCollection.doc(groupID).update({
      'recent_message_sender': chatMessageData['sender'],
      'recent_message': chatMessageData['message'],
      'recent_message_time': chatMessageData['time'].toString(),
    });
  }
}
