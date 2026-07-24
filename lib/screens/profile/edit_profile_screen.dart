import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_snackbar.dart';
import '../../providers/edit_profile_controller.dart';
import '../../providers/profile_controller.dart';
import '../../utils/validators.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/phone_input_field.dart';
import '../../widgets/common/primary_loading_button.dart';
import '../../widgets/common/responsive_body.dart';

/// Formulaire de modification du profil (prénom, nom, téléphone).
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(profileControllerProvider).requireValue;
    _firstNameController = TextEditingController(text: user.firstName);
    _lastNameController = TextEditingController(text: user.lastName);
    _phoneController = TextEditingController(text: user.phoneNumber);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(editProfileControllerProvider.notifier).submit(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        );

    if (!mounted) return;
    if (success) {
      context.pop();
      AppSnackBar.success(context, 'Profil mis à jour avec succès.');
    } else {
      final error = ref.read(editProfileControllerProvider).error;
      AppSnackBar.error(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(editProfileControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
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
                  title: 'Vos informations',
                  subtitle: 'Mettez à jour vos coordonnées',
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
                PrimaryLoadingButton(
                  label: 'Enregistrer',
                  isLoading: isLoading,
                  onPressed: _submit,
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
