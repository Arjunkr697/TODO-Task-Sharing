import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Stream for real-time updates
  Stream<List<Task>> getTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return Task.fromMap(data);
      }).toList();
    });
  }
  
  // Stream for shared tasks
  Stream<List<Task>> getSharedTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('sharedWith', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return Task.fromMap(data);
      }).toList();
    });
  }

  Future<void> addTask(Task task) {
    return _firestore.collection('tasks').doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(Task task) {
    return _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) {
    return _firestore.collection('tasks').doc(taskId).delete();
  }

  Future<void> shareTask(String taskId, String email) async {
    // First get the user ID from email
    var userDoc = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    
    if (userDoc.docs.isEmpty) {
      throw Exception('User not found');
    }
    
    String userId = userDoc.docs.first.id;
    
    // Update the task's sharedWith array
    return _firestore.collection('tasks').doc(taskId).update({
      'sharedWith': FieldValue.arrayUnion([userId])
    });
  }
}