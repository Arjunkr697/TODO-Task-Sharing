import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();
  final Uuid _uuid = const Uuid();
  
  List<Task> _tasks = [];
  List<Task> _sharedWithMe = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  List<Task> get sharedWithMe => _sharedWithMe;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentUserId => _authService.currentUser?.uid;

  TaskViewModel() {
    _initStreams();
  }

  void _initStreams() {
    if (_authService.currentUser != null) {
      // Listen to owned tasks
      _taskService.getTasks(_authService.currentUser!.uid).listen((tasks) {
        _tasks = tasks;
        notifyListeners();
      });
      
      // Listen to shared tasks
      _taskService.getSharedTasks(_authService.currentUser!.uid).listen((tasks) {
        _sharedWithMe = tasks;
        notifyListeners();
      });
    }
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signIn(email, password);
      _initStreams();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(String email, String password, String name) async {
    _setLoading(true);
    try {
      await _authService.register(email, password, name);
      _initStreams();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _tasks = [];
      _sharedWithMe = [];
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTask(String title, String description) async {
    if (_authService.currentUser == null) {
      _error = 'User not signed in';
      notifyListeners();
      return;
    }
    
    _setLoading(true);
    try {
      final task = Task(
        id: _uuid.v4(),
        title: title,
        description: description,
        ownerId: _authService.currentUser!.uid,
        sharedWith: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _taskService.addTask(task);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTask(Task task) async {
    _setLoading(true);
    try {
      task.updatedAt = DateTime.now();
      await _taskService.updateTask(task);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTask(String taskId) async {
    _setLoading(true);
    try {
      await _taskService.deleteTask(taskId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> shareTask(String taskId, String email) async {
    _setLoading(true);
    try {
      await _taskService.shareTask(taskId, email);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> shareTaskViaApp(Task task) async {
    try {
      await Share.share(
        'Check out this task: ${task.title}\n\n${task.description}',
        subject: 'Task from Task Sharing App',
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}