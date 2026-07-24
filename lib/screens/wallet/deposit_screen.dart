import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_snackbar.dart';
import '../../providers/deposit_controller.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/common/primary_loading_button.dart';
import '../../widgets/common/responsive_body.dart';
import '../../widgets/wallet/amount_input_field.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    final success =
        await ref.read(depositControllerProvider.notifier).submit(amount: amount);

    if (!mounted) return;
    if (success) {
      context.pop();
      AppSnackBar.success(context, 'Dépôt effectué avec succès.');
    } else {
      final error = ref.read(depositControllerProvider).error;
      AppSnackBar.error(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(depositControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Dépôt')),
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
                    title: 'Créditer votre wallet',
                    subtitle: 'Entrez le montant que vous souhaitez déposer',
                  ),
                  const SizedBox(height: AppDimens.spaceXl),
                  AmountInputField(controller: _amountController, enabled: !isLoading),
                  const SizedBox(height: AppDimens.spaceLg),
                  PrimaryLoadingButton(
                    label: 'Déposer',
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
