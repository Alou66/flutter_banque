import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_snackbar.dart';
import '../../models/registration_data.dart';
import '../../providers/register_controller.dart';
import '../../routes/route_paths.dart';
import '../../utils/validators.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/phone_input_field.dart';
import '../../widgets/common/responsive_body.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = RegistrationData(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    final success = await ref.read(registerControllerProvider.notifier).submit(
          firstName: data.firstName,
          lastName: data.lastName,
          phoneNumber: data.phoneNumber,
        );

    if (!mounted) return;
    if (success) {
      context.push(RoutePaths.otp, extra: data);
    } else {
      final error = ref.read(registerControllerProvider).error;
      AppSnackBar.error(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(registerControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ResponsiveBody(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(
                  title: 'Créer un compte',
                  subtitle: 'Renseignez vos informations personnelles',
                ),
                const SizedBox(height: AppDimens.spaceXl),
                TextFormField(
                  controller: _firstNameController,
                  enabled: !isLoading,
                  validator: Validators.name,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                TextFormField(
                  controller: _lastNameController,
                  enabled: !isLoading,
                  validator: Validators.name,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                PhoneInputField(controller: _phoneController, enabled: !isLoading),
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
                      : const Text('Continuer'),
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
