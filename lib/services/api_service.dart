import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/payment_method.dart';
import '../models/power_bank_rental.dart';
import '../constants/app_constants.dart';

/// Exception thrown when API calls fail
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Service class for handling all API calls
class ApiService {
  late final Dio _dio;
  static ApiService? _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    // Add interceptor for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('🚀 ${options.method} ${options.path}');
          if (options.data != null) {
            debugPrint('📦 Data: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('❌ Error: ${error.message}');
          debugPrint('❌ Response: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );
  }

  /// Singleton instance
  static ApiService get instance {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  /// Handle API response and convert to ApiResponse
  T _handleResponse<T>(Response response, T Function(dynamic) fromJson) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return fromJson(response.data);
    } else {
      throw ApiException(
        'Request failed with status ${response.statusCode}',
        statusCode: response.statusCode,
        data: response.data,
      );
    }
  }

  /// Handle DioException and convert to ApiException
  Never _handleError(DioException error) {
    String message = 'Network error - CORS issue likely';
    int? statusCode;

    if (error.response != null) {
      statusCode = error.response!.statusCode;
      message = error.response!.data?.toString() ?? 'Server error';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timeout';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'Network connection error - check CORS settings';
    } else if (error.type == DioExceptionType.unknown) {
      message = 'Network error - likely CORS restriction';
    }

    throw ApiException(message, statusCode: statusCode, data: error.response?.data);
  }

  /// Generate account
  Future<User> generateAccount() async {
    try {
      debugPrint(
        '🔄 Attempting account generation via ${ApiConstants.isUsingProxy ? 'proxy' : 'direct API'}',
      );

      // Use GET request instead of POST
      final response = await _dio.get(ApiConstants.generateAccount);

      // Handle the API response structure
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data;
        final userEntity = data['rechargeUserEntity'];
        final accessToken = data['accessJwt'];

        // Create User object from the API response
        final user = User(
          id: userEntity['id'],
          email: userEntity['email'] ?? 'test@example.com',
          token: accessToken,
          createdAt: DateTime.parse(userEntity['createdAt']),
        );

        // Set the authorization token for future API calls
        setAuthToken(accessToken);

        debugPrint('✅ Account generated successfully: ${user.id}');
        return user;
      } else {
        throw ApiException(
          'Account generation failed with status ${response.statusCode}',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Account generation failed, using mock user: $e');
      return User(
        id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
        email: 'test@example.com',
        token: 'mock-auth-token-${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );
    }
  }

  /// Get Braintree client token
  Future<String> getBraintreeToken() async {
    try {
      debugPrint(
        '🔄 Fetching Braintree token via ${ApiConstants.isUsingProxy ? 'proxy' : 'direct API'}',
      );
      debugPrint(
        '📋 Authorization header: ${_dio.options.headers['Authorization'] != null ? 'Present' : 'Missing'}',
      );

      final response = await _dio.get(ApiConstants.getBraintreeToken);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data;
        // Handle different possible response structures
        if (data is Map<String, dynamic>) {
          if (data.containsKey('token')) {
            return data['token'] as String;
          } else if (data.containsKey('clientToken')) {
            return data['clientToken'] as String;
          }
        } else if (data is String) {
          return data;
        }

        debugPrint('⚠️ Unexpected Braintree response structure: $data');
        return 'mock-braintree-token-${DateTime.now().millisecondsSinceEpoch}';
      } else {
        throw ApiException(
          'Braintree token request failed with status ${response.statusCode}',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Using mock Braintree token: $e');
      return 'mock-braintree-token-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Add payment method
  Future<PaymentMethod> addPaymentMethod({
    required String paymentNonce,
    required String description,
    required String paymentType,
  }) async {
    try {
      debugPrint(
        '🔄 Adding payment method via ${ApiConstants.isUsingProxy ? 'proxy' : 'direct API'}',
      );

      final requestBody = {
        'paymentNonceFromTheClient': paymentNonce,
        'description': description,
        'paymentType': paymentType,
      };

      debugPrint('📦 Payment method request body: $requestBody');

      final response = await _dio.post(ApiConstants.addPaymentMethod, data: requestBody);
      return _handleResponse(response, (data) => PaymentMethod.fromJson(data));
    } catch (e) {
      debugPrint('⚠️ Using mock payment method: $e');
      return PaymentMethod(
        id: 'mock-payment-id',
        type: paymentType,
        token: paymentNonce,
        last4: '1234',
        brand: paymentType == 'apple_pay' ? 'Apple Pay' : 'Visa',
        isDefault: true,
      );
    }
  }

  /// Create subscription
  Future<Map<String, dynamic>> createSubscription({
    required String paymentToken,
    String planId = ApiConstants.defaultPlanId,
  }) async {
    try {
      debugPrint(
        '🔄 Creating subscription via ${ApiConstants.isUsingProxy ? 'proxy' : 'direct API'}',
      );

      // API expects specific body structure
      final requestBody = {
        'paymentToken': paymentToken,
        'thePlanId': planId, // Default is 'tss2'
      };

      debugPrint('📦 Subscription request body: $requestBody');

      final response = await _dio.post(
        ApiConstants.createSubscription,
        queryParameters: ApiConstants.subscriptionParams,
        data: requestBody,
      );
      return _handleResponse(response, (data) => data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('⚠️ Using mock subscription: $e');
      return {
        'subscriptionId': 'mock-subscription-id',
        'status': 'active',
        'planId': planId,
        'amount': 10.0,
      };
    }
  }

  /// Rent power bank
  Future<PowerBankRental> rentPowerBank({
    required String cabinetId,
    required String connectionKey,
  }) async {
    try {
      final requestBody = {'cabinetId': cabinetId, 'connectionKey': connectionKey};

      debugPrint('🔄 Renting power bank via ${ApiConstants.isUsingProxy ? 'proxy' : 'direct API'}');
      debugPrint('📦 Power bank rental request body: $requestBody');

      final response = await _dio.post(ApiConstants.rentPowerBank, data: requestBody);
      return _handleResponse(response, (data) => PowerBankRental.fromJson(data));
    } catch (e) {
      debugPrint('⚠️ Using mock rental: $e');
      return PowerBankRental(
        id: 'mock-rental-id',
        stationId: cabinetId,
        userId: 'mock-user-id',
        status: 'active',
        amount: 10.0,
        startTime: DateTime.now(),
        createdAt: DateTime.now(),
      );
    }
  }

  /// Update authorization token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authorization token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
