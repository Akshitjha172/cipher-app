import 'package:expense_tracker/data/models/user_model/user_model.dart';
import 'package:expense_tracker/data/repositories/auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<bool> isLoggedIn() async {
    return await _authRepository.isLoggedIn();
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authRepository.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authRepository.signOut();
    _user = null;

    _isLoading = false;
    notifyListeners();
  }

  Future<User?> getCurrentUser() async {
    if (_user != null) return _user;

    _isLoading = true;
    notifyListeners();

    _user = await _authRepository.getCurrentUser();

    _isLoading = false;
    notifyListeners();

    return _user;
  }
}
