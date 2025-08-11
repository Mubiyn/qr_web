import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  /// Generate account and authenticate user
  Future<bool> generateAccount() async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _apiService.generateAccount();

      // Set auth token for future requests
      if (_user?.token != null) {
        _apiService.setAuthToken(_user!.token!);
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create account: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Clear user session
  void logout() {
    _user = null;
    _apiService.clearAuthToken();
    _clearError();
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error state
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error state
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
