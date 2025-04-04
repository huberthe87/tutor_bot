import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;

  Future<void> login(String email, String password) async {
    // Implement login logic
    _isAuthenticated = true;
    _userId = 'user123';
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _userId = null;
    notifyListeners();
  }
} 