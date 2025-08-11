/// API constants and configuration
class ApiConstants {
  // Dynamic base URL based on environment
  static String get baseUrl {
    // Check if running on GitHub Pages
    if (Uri.base.host.contains('github.io')) {
      // Use CORS proxy for GitHub Pages deployment
      return 'https://api.allorigins.win/raw?url=https://goldfish-app-3lf7u.ondigitalocean.app';
    }
    // Use local proxy for development
    return 'http://localhost:8081';
  }

  // Fallback for const contexts
  static const String fallbackBaseUrl = 'https://api.allorigins.win/raw?url=https://goldfish-app-3lf7u.ondigitalocean.app';

  // API Endpoints
  static const String generateAccount = '/api/v1/auth/apple/generate-account';
  static const String getBraintreeToken =
      '/api/v1/payments/generate-and-save-braintree-client-token';
  static const String addPaymentMethod = '/api/v1/payments/add-payment-method';
  static const String createSubscription =
      '/api/v1/payments/subscription/create-subscription-transaction-v2';
  static const String rentPowerBank = '/api/v1/payments/rent-power-bank';

  // Query parameters
  static const Map<String, dynamic> subscriptionParams = {
    'disableWelcomeDiscount': false,
    'welcomeDiscount': 10,
  };

  // Default values
  static const String defaultPlanId = 'tss2';
  static const String testStationId = 'RECH082203000350';
}

/// App UI constants
class AppConstants {
  static const String appName = 'PowerBank Rental';

  // App Store links (placeholder - update with actual links)
  static const String iosAppStoreUrl = 'https://apps.apple.com/ng/app/recharge-city/id1594160460';
  static const String androidPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=your.app';

  // UI Strings (Russian)
  static const String paymentTitle = 'Аренда PowerBank';
  static const String stationLabel = 'Станция:';
  static const String choosePaymentMethod = 'Выберите способ оплаты';
  static const String applePayButton = 'Apple Pay';
  static const String cardPayButton = 'Банковская карта';
  static const String processing = 'Обработка платежа...';
  static const String success = 'Успешно!';
  static const String powerBankDispensed = 'PowerBank выдан';
  static const String downloadApp = 'Скачать приложение';
  static const String paymentFailed = 'Ошибка оплаты';
  static const String tryAgain = 'Попробовать снова';
}

/// App colors and theme constants
class AppColors {
  static const int primaryBlue = 0xFF1E88E5;
  static const int backgroundGrey = 0xFFF5F5F5;
  static const int cardBackground = 0xFFFFFFFF;
  static const int textPrimary = 0xFF333333;
  static const int textSecondary = 0xFF666666;
  static const int successGreen = 0xFF4CAF50;
  static const int errorRed = 0xFFF44336;
}
