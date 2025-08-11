import 'package:flutter/foundation.dart';
import '../models/power_bank_rental.dart';
import '../services/api_service.dart';

enum RentalState { idle, requesting, dispensing, success, failed }

/// Provider for managing power bank rental flow
class RentalProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  String? _stationId;
  PowerBankRental? _currentRental;
  RentalState _rentalState = RentalState.idle;
  String? _error;
  final bool _isLoading = false;

  // Getters
  String? get stationId => _stationId;
  PowerBankRental? get currentRental => _currentRental;
  RentalState get rentalState => _rentalState;
  String? get error => _error;
  bool get isLoading => _isLoading;

  bool get isRentalInProgress =>
      _rentalState == RentalState.requesting || _rentalState == RentalState.dispensing;
  bool get isRentalSuccessful => _rentalState == RentalState.success;
  bool get isRentalFailed => _rentalState == RentalState.failed;

  /// Set station ID from deep link
  void setStationId(String stationId) {
    _stationId = stationId;
    _clearError();
    notifyListeners();
  }

  /// Start power bank rental process
  Future<bool> rentPowerBank() async {
    if (_stationId == null) {
      _setError('Station ID is required');
      return false;
    }

    _setRentalState(RentalState.requesting);
    _clearError();

    try {
      _currentRental = await _apiService.rentPowerBank(stationId: _stationId!);

      // Set start time if not provided by API
      if (_currentRental != null && _currentRental!.startTime == null) {
        _currentRental = _currentRental!.copyWith(
          startTime: DateTime.now(),
          createdAt: DateTime.now(),
        );
      }

      // Simulate dispensing process
      _setRentalState(RentalState.dispensing);

      // Wait for a moment to simulate physical dispensing
      await Future.delayed(const Duration(seconds: 3));

      _setRentalState(RentalState.success);
      return true;
    } catch (e) {
      _setError('Failed to rent power bank: ${e.toString()}');
      _setRentalState(RentalState.failed);
      return false;
    }
  }

  /// Reset rental state
  void resetRental() {
    _rentalState = RentalState.idle;
    _currentRental = null;
    _stationId = null;
    _clearError();
    notifyListeners();
  }

  /// Set rental state
  void _setRentalState(RentalState state) {
    _rentalState = state;
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
