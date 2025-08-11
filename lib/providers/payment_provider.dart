import 'package:flutter/foundation.dart';
import '../models/payment_method.dart';
import '../services/api_service.dart';

enum PaymentType { applePay, card }

enum PaymentState { idle, processing, success, failed }

/// Provider for managing payment flow
class PaymentProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  PaymentMethod? _selectedPaymentMethod;
  PaymentType? _selectedPaymentType;
  PaymentState _paymentState = PaymentState.idle;
  String? _braintreeToken;
  String? _error;
  bool _isLoading = false;

  // Getters
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  PaymentType? get selectedPaymentType => _selectedPaymentType;
  PaymentState get paymentState => _paymentState;
  String? get braintreeToken => _braintreeToken;
  String? get error => _error;
  bool get isLoading => _isLoading;

  bool get canPay => _selectedPaymentType != null && !_isLoading;
  bool get isProcessing => _paymentState == PaymentState.processing;
  bool get paymentSuccessful => _paymentState == PaymentState.success;
  bool get paymentFailed => _paymentState == PaymentState.failed;

  /// Set selected payment type
  void selectPaymentType(PaymentType type) {
    _selectedPaymentType = type;
    _clearError();
    notifyListeners();
  }

  /// Get Braintree client token
  Future<bool> initializeBraintree() async {
    _setLoading(true);
    _clearError();

    try {
      _braintreeToken = await _apiService.getBraintreeToken();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize payment: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Process payment
  Future<bool> processPayment({required String paymentToken}) async {
    if (_selectedPaymentType == null) {
      _setError('Please select a payment method');
      return false;
    }

    _setPaymentState(PaymentState.processing);
    _clearError();

    try {
      // Add a small delay to make loading visible
      await Future.delayed(const Duration(milliseconds: 500));

      // Add payment method
      final paymentMethod = await _apiService.addPaymentMethod(
        paymentNonce: paymentToken,
        description: _selectedPaymentType == PaymentType.applePay
            ? 'Apple Pay Payment'
            : 'Credit Card Payment',
        paymentType: _selectedPaymentType == PaymentType.applePay ? 'apple_pay' : 'credit_card',
      );

      _selectedPaymentMethod = paymentMethod;

      // Create subscription
      await _apiService.createSubscription(paymentToken: paymentToken);

      _setPaymentState(PaymentState.success);
      return true;
    } catch (e) {
      _setError('Payment failed: ${e.toString()}');
      _setPaymentState(PaymentState.failed);
      return false;
    }
  }

  /// Reset payment state
  void resetPayment() {
    _paymentState = PaymentState.idle;
    _selectedPaymentMethod = null;
    _selectedPaymentType = null;
    _clearError();
    notifyListeners();
  }

  /// Set payment state
  void _setPaymentState(PaymentState state) {
    _paymentState = state;
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
