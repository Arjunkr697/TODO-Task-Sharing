import 'package:flutter/material.dart';
import 'package:task_mgmt/viewmodels/user_model.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  final Map<String, UserModel> _userCache = {};
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCurrentUser() async {
    if (_authService.currentUser == null) {
      _currentUser = null;
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      final userId = _authService.currentUser!.uid;
      _currentUser = await _userService.getUserById(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    _setLoading(true);
    try {
      final user = await _userService.getUserByEmail(email);
      if (user != null) {
        _userCache[user.id] = user;
      }
      _error = null;
      return user;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    // Check cache first
    if (_userCache.containsKey(userId)) {
      return _userCache[userId];
    }

    _setLoading(true);
    try {
      final user = await _userService.getUserById(userId);
      if (user != null) {
        _userCache[userId] = user;
      }
      _error = null;
      return user;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    final List<String> missingIds = [];
    final List<UserModel> cachedUsers = [];

    // Check which users we already have in cache
    for (final id in userIds) {
      if (_userCache.containsKey(id)) {
        cachedUsers.add(_userCache[id]!);
      } else {
        missingIds.add(id);
      }
    }

    // If all users are in cache, return immediately
    if (missingIds.isEmpty) {
      return cachedUsers;
    }

    _setLoading(true);
    try {
      final fetchedUsers = await _userService.getUsersByIds(missingIds);
      
      // Add fetched users to cache
      for (final user in fetchedUsers) {
        _userCache[user.id] = user;
      }
      
      _error = null;
      return [...cachedUsers, ...fetchedUsers];
    } catch (e) {
      _error = e.toString();
      return cachedUsers; // Return whatever we have in cache
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}