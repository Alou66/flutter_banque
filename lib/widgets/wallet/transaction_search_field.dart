import 'dart:async';
import 'package:flutter/material.dart';

/// Champ de recherche des transactions, avec anti-rebond pour éviter un
/// appel au repository à chaque frappe.
class TransactionSearchField extends StatefulWidget {
  const TransactionSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<TransactionSearchField> createState() => _TransactionSearchFieldState();
}

class _TransactionSearchFieldState extends State<TransactionSearchField> {
  Timer? _debounce;

  void _handleChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => widget.onChanged(value),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _handleChanged,
      decoration: const InputDecoration(
        hintText: 'Rechercher une transaction...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
