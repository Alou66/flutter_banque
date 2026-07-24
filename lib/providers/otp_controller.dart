import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';

/// Gère la vérification du code OTP reçu par l'utilisateur.
class OtpController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> verify({
    required String phoneNumber,
    required String otp,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).verifyOtp(
            phoneNumber: phoneNumber,
            otp: otp,
          ),
    );
    return !state.hasError;
  }
}

final otpControllerProvider =
    AsyncNotifierProvider<OtpController, void>(OtpController.new);
