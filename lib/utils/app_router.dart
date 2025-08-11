import 'package:go_router/go_router.dart';
import '../screens/payment_screen.dart';
import '../screens/success_screen.dart';
import '../constants/app_constants.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/payment/${ApiConstants.testStationId}',
    routes: [
      GoRoute(
        path: '/payment/:stationId',
        builder: (context, state) {
          final stationId = state.pathParameters['stationId'] ?? ApiConstants.testStationId;
          return PaymentScreen(stationId: stationId);
        },
      ),
      GoRoute(path: '/success', builder: (context, state) => const SuccessScreen()),
    ],
    errorBuilder: (context, state) => PaymentScreen(stationId: ApiConstants.testStationId),
  );
}
