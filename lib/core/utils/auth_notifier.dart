import 'package:flutter/foundation.dart';

/// Lightweight, singleton notifier that tracks whether the user is
/// authenticated.  GoRouter listens to this via [refreshListenable] so that
/// route guards automatically re-evaluate whenever auth state changes.
class AuthNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
