import 'package:flutter/material.dart';
import 'package:mutual_fund/core/storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  final StorageService _storageService;

  AuthViewModel(this._storageService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    _isLoggedIn = await _storageService.isLoggedIn();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // validation
    if (email.isEmpty) {
      _errorMessage = 'Email cannot be empty.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _errorMessage = 'Please enter a valid email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.isEmpty) {
      _errorMessage = 'Password cannot be empty.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters long';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // hardcoded authentication token
    final generatedToken = 'dummy_auth_token_${DateTime.now().millisecondsSinceEpoch}';
    debugPrint('Generated Token: $generatedToken');
    await _storageService.saveToken(generatedToken);
    _isLoggedIn = true;

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
    _isLoggedIn = false;
    notifyListeners();
  }
}
