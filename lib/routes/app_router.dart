import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/registration_data.dart';
import '../models/transaction.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/pin_setup_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/profile/change_pin_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/wallet/deposit_screen.dart';
import '../screens/wallet/payment_screen.dart';
import '../screens/wallet/transaction_detail_screen.dart';
import '../screens/wallet/transactions_screen.dart';
import '../screens/wallet/wallet_dashboard_screen.dart';
import '../screens/wallet/withdraw_screen.dart';
import 'page_transitions.dart';
import 'route_paths.dart';

/// Fournit l'instance unique de [GoRouter] utilisée par l'application.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        pageBuilder: (context, state) =>
            buildPageTransition(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) =>
            buildPageTransition(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        path: RoutePaths.register,
        pageBuilder: (context, state) =>
            buildPageTransition(state: state, child: const RegisterScreen()),
      ),
      GoRoute(
        path: RoutePaths.otp,
        redirect: (context, state) =>
            state.extra is RegistrationData ? null : RoutePaths.register,
        pageBuilder: (context, state) => buildPageTransition(
          state: state,
          child: OtpScreen(data: state.extra as RegistrationData),
        ),
      ),
      GoRoute(
        path: RoutePaths.pinSetup,
        redirect: (context, state) =>
            state.extra is RegistrationData ? null : RoutePaths.register,
        pageBuilder: (context, state) => buildPageTransition(
          state: state,
          child: PinSetupScreen(data: state.extra as RegistrationData),
        ),
      ),
      GoRoute(
        path: RoutePaths.home,
        pageBuilder: (context, state) => buildPageTransition(
          state: state,
          child: const WalletDashboardScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.deposit,
        pageBuilder: (context, state) =>
            buildPageTransition(state: state, child: const DepositScreen()),
      ),
      GoRoute(
        path: RoutePaths.withdraw,
        pageBuilder: (context, state) =>
            buildPageTransition(state: state, child: const WithdrawScreen()),
      ),
      GoRoute(
        path: RoutePaths.payment,
        pageBuilder: (context, state) =>
            buildPageTransition(state: state, child: const PaymentScreen()),
      ),
      GoRoute(
        path: RoutePaths.transactions,
        pageBuilder: (context, state) => buildPageTransition(
          state: state,
          child: const TransactionsScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.transactionDetail,
        redirect: (context, state) =>
            state.extra is Transaction ? null : RoutePaths.transactions,
        pageBuilder: (context, state) => buildPageTransition(
          state: state,
          child: TransactionDetailScreen(transaction: state.extra as Transaction),
        ),
      ),
      GoRoute(
        path: RoutePaths.profile,
        pageBuilder: (context, state) =>
            buildPageTransition(state: state, child: const ProfileScreen()),
      ),
      GoRoute(
        path: RoutePaths.profileEdit,
        pageBuilder: (context, state) => buildPageTransition(
          state: state,
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.profileChangePin,
        pageBuilder: (context, state) => buildPageTransition(
          state: state,
          child: const ChangePinScreen(),
        ),
      ),
    ],
  );
});
