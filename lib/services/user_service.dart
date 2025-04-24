import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_mgmt/viewmodels/user_model.dart';


class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserByEmail(String email) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final doc = querySnapshot.docs.first;
    final data = doc.data();
    data['id'] = doc.id;
    
    return UserModel.fromMap(data);
  }

  Future<UserModel?> getUserById(String userId) async {
    final docSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .get();

    if (!docSnapshot.exists) {
      return null;
    }

    final data = docSnapshot.data()!;
    data['id'] = docSnapshot.id;
    
    return UserModel.fromMap(data);
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) {
      return [];
    }

    // Firestore has a limit on how many items we can query at once
    // So we'll chunk the requests if needed
    const int chunkSize = 10;
    final List<UserModel> result = [];

    for (int i = 0; i < userIds.length; i += chunkSize) {
      final int end = (i + chunkSize < userIds.length) ? i + chunkSize : userIds.length;
      final chunk = userIds.sublist(i, end);

      final querySnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        result.add(UserModel.fromMap(data));
      }
    }

    return result;
  }
}