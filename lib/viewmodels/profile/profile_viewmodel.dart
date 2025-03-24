import 'package:expense_tracker/data/models/user_model/user_model.dart';
import 'package:expense_tracker/data/repositories/auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();

    _user = await _authRepository.getCurrentUser();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authRepository.signOut();
    _user = null;

    _isLoading = false;
    notifyListeners();
  }
}
