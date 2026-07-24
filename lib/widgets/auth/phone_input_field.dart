import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/validators.dart';

/// Champ de saisie de numéro de téléphone, avec validation intégrée.
class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: Validators.phone,
      decoration: const InputDecoration(
        labelText: 'Numéro de téléphone',
        hintText: 'Ex : 700000000',
        prefixIcon: Icon(Icons.phone_outlined),
      ),
    );
  }
}
