import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/registration_data.dart';
import '../../providers/otp_controller.dart';
import '../../routes/route_paths.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/code_input_field.dart';
import '../../widgets/common/responsive_body.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.data});

  final RegistrationData data;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String _otp = '';
  String? _error;

  Future<void> _submit() async {
    if (_otp.length != 6) {
      setState(() => _error = 'Le code doit contenir 6 chiffres.');
      return;
    }

    final success = await ref.read(otpControllerProvider.notifier).verify(
          phoneNumber: widget.data.phoneNumber,
          otp: _otp,
        );

    if (!mounted) return;
    if (success) {
      context.push(RoutePaths.pinSetup, extra: widget.data);
    } else {
      final error = ref.read(otpControllerProvider).error;
      setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(otpControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ResponsiveBody(
          child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: 'Vérification',
                subtitle:
                    'Entrez le code envoyé au ${widget.data.phoneNumber}',
              ),
              const SizedBox(height: AppDimens.spaceXl),
              CodeInputField(
                length: 6,
                onChanged: (value) => setState(() {
                  _otp = value;
                  _error = null;
                }),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppDimens.spaceSm),
                Text(
                  _error!,
                  style: AppTextStyles.caption(context)
                      .copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: AppDimens.spaceSm),
              Text(
                'Simulation — code de test : 123456',
                style: AppTextStyles.caption(context),
              ),
              const SizedBox(height: AppDimens.spaceLg),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Vérifier'),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
