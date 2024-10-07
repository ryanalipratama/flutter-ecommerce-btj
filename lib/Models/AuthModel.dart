import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String? _token;
  int? _userId;
  bool _isLoggedIn = false;

  String? get token => _token;
  int? get userId => _userId;
  bool get isLoggedIn => _isLoggedIn;
  

  void setToken(String? token) {
    _token = token;
    _userId = userId;
    _isLoggedIn = token != null;
    notifyListeners();
  }

  void setUserId(int? userId) {
    _userId = userId;
    debugPrint('User ID set: $_userId');
    notifyListeners();
  }

  void logout() {
    _token = null;
    _userId = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}