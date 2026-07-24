import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_snackbar.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/login_controller.dart';
import '../../routes/route_paths.dart';
import '../../utils/validators.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/code_input_field.dart';
import '../../widgets/auth/phone_input_field.dart';
import '../../widgets/common/responsive_body.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _pin = '';
  String? _pinError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    final isFormValid = _formKey.currentState!.validate();
    final pinError = Validators.pin(_pin);
    setState(() => _pinError = pinError);
    if (!isFormValid || pinError != null) return;

    ref.read(loginControllerProvider.notifier).login(
          phoneNumber: _phoneController.text.trim(),
          pin: _pin,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) context.go(RoutePaths.home);
        },
        error: (error, _) {
          AppSnackBar.error(context, error.toString());
        },
      );
    });

    final isLoading = ref.watch(loginControllerProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveBody(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimens.spaceXxl),
                const AuthHeader(
                  title: 'Connexion',
                  subtitle: 'Accédez à votre compte Banque',
                ),
                const SizedBox(height: AppDimens.spaceXl),
                PhoneInputField(controller: _phoneController, enabled: !isLoading),
                const SizedBox(height: AppDimens.spaceLg),
                Text('Code PIN', style: AppTextStyles.bodySecondary(context)),
                const SizedBox(height: AppDimens.spaceSm),
                CodeInputField(
                  length: 4,
                  obscure: true,
                  autofocus: false,
                  onChanged: (value) => setState(() {
                    _pin = value;
                    _pinError = null;
                  }),
                ),
                if (_pinError != null) ...[
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    _pinError!,
                    style: AppTextStyles.caption(context)
                        .copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: AppDimens.spaceSm),
                Text(
                  'Compte démo : 700000000 / 1234',
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
                      : const Text('Se connecter'),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                Center(
                  child: TextButton(
                    onPressed:
                        isLoading ? null : () => context.push(RoutePaths.register),
                    child: const Text('Pas de compte ? Inscrivez-vous'),
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}
