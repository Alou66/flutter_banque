import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/validators.dart';

/// Champ de saisie de montant, réutilisable pour Dépôt, Retrait et Paiement.
class AmountInputField extends StatelessWidget {
  const AmountInputField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.maxAmount,
  });

  final TextEditingController controller;
  final bool enabled;
  final double? maxAmount;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      validator: (value) => Validators.amount(value, maxAmount: maxAmount),
      decoration: const InputDecoration(
        labelText: 'Montant',
        hintText: 'Ex : 10000',
        prefixIcon: Icon(Icons.payments_outlined),
        suffixText: 'FCFA',
      ),
    );
  }
}
