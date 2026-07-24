import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_snackbar.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/payment_controller.dart';
import '../../providers/wallet_dashboard_controller.dart';
import '../../utils/formatters.dart';
import '../../utils/validators.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/code_input_field.dart';
import '../../widgets/common/primary_loading_button.dart';
import '../../widgets/common/responsive_body.dart';
import '../../widgets/wallet/amount_input_field.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _labelController = TextEditingController();
  String _pin = '';
  String? _pinError;

  @override
  void dispose() {
    _amountController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isFormValid = _formKey.currentState!.validate();
    final pinError = _pin.length != 4
        ? 'Le code PIN doit contenir 4 chiffres.'
        : null;
    setState(() => _pinError = pinError);
    if (!isFormValid || pinError != null) return;

    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    final success = await ref.read(paymentControllerProvider.notifier).submit(
          amount: amount,
          label: _labelController.text.trim(),
          pin: _pin,
        );

    if (!mounted) return;
    if (success) {
      context.pop();
      AppSnackBar.success(context, 'Paiement effectué avec succès.');
    } else {
      final error = ref.read(paymentControllerProvider).error;
      AppSnackBar.error(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(paymentControllerProvider).isLoading;
    final balance =
        ref.watch(walletDashboardControllerProvider).value?.wallet.balance;

    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
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
                  title: 'Payer une facture',
                  subtitle: balance != null
                      ? 'Solde disponible : ${Formatters.amount(balance)}'
                      : 'Entrez les détails du paiement',
                ),
                const SizedBox(height: AppDimens.spaceXl),
                TextFormField(
                  controller: _labelController,
                  enabled: !isLoading,
                  validator: Validators.name,
                  decoration: const InputDecoration(
                    labelText: 'Motif / Destinataire',
                    hintText: 'Ex : Facture SEG',
                    prefixIcon: Icon(Icons.receipt_long_outlined),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMd),
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
                  label: 'Payer',
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
