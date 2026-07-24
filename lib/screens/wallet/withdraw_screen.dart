import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_snackbar.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/wallet_dashboard_controller.dart';
import '../../providers/withdraw_controller.dart';
import '../../utils/formatters.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/code_input_field.dart';
import '../../widgets/common/primary_loading_button.dart';
import '../../widgets/common/responsive_body.dart';
import '../../widgets/wallet/amount_input_field.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({super.key});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _pin = '';
  String? _pinError;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isFormValid = _formKey.currentState!.validate();
    final pinError = _validatePin(_pin);
    setState(() => _pinError = pinError);
    if (!isFormValid || pinError != null) return;

    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    final success = await ref
        .read(withdrawControllerProvider.notifier)
        .submit(amount: amount, pin: _pin);

    if (!mounted) return;
    if (success) {
      context.pop();
      AppSnackBar.success(context, 'Retrait effectué avec succès.');
    } else {
      final error = ref.read(withdrawControllerProvider).error;
      AppSnackBar.error(context, error.toString());
    }
  }

  String? _validatePin(String value) {
    if (value.length != 4) return 'Le code PIN doit contenir 4 chiffres.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(withdrawControllerProvider).isLoading;
    final balance =
        ref.watch(walletDashboardControllerProvider).value?.wallet.balance;

    return Scaffold(
      appBar: AppBar(title: const Text('Retrait')),
      body: SafeArea(
        child: ResponsiveBody(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(
                  title: 'Retirer des fonds',
                  subtitle: balance != null
                      ? 'Solde disponible : ${Formatters.amount(balance)}'
                      : 'Entrez le montant à retirer',
                ),
                const SizedBox(height: AppDimens.spaceXl),
                AmountInputField(
                  controller: _amountController,
                  enabled: !isLoading,
                  maxAmount: balance,
                ),
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
                const SizedBox(height: AppDimens.spaceLg),
                PrimaryLoadingButton(
                  label: 'Retirer',
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
