import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_snackbar.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/change_pin_controller.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/code_input_field.dart';
import '../../widgets/common/responsive_body.dart';

enum _ChangePinStep { current, create, confirm }

/// Changement de PIN en 3 étapes : ancien code, nouveau code, confirmation.
class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  _ChangePinStep _step = _ChangePinStep.current;
  String _currentPin = '';
  String _newPin = '';
  String? _error;

  void _handleChanged(String value) {
    setState(() => _error = null);
    if (value.length != 4) return;

    switch (_step) {
      case _ChangePinStep.current:
        setState(() {
          _currentPin = value;
          _step = _ChangePinStep.create;
        });
      case _ChangePinStep.create:
        setState(() {
          _newPin = value;
          _step = _ChangePinStep.confirm;
        });
      case _ChangePinStep.confirm:
        if (value == _newPin) {
          _submit();
        } else {
          setState(() {
            _error = 'Les codes PIN ne correspondent pas. Réessayez.';
            _step = _ChangePinStep.create;
            _newPin = '';
          });
        }
    }
  }

  Future<void> _submit() async {
    final success = await ref.read(changePinControllerProvider.notifier).submit(
          currentPin: _currentPin,
          newPin: _newPin,
        );

    if (!mounted) return;
    if (success) {
      context.pop();
      AppSnackBar.success(context, 'Code PIN modifié avec succès.');
    } else {
      final error = ref.read(changePinControllerProvider).error;
      setState(() {
        _error = error.toString();
        _step = _ChangePinStep.current;
        _currentPin = '';
        _newPin = '';
      });
    }
  }

  String get _title {
    switch (_step) {
      case _ChangePinStep.current:
        return 'Ancien code PIN';
      case _ChangePinStep.create:
        return 'Nouveau code PIN';
      case _ChangePinStep.confirm:
        return 'Confirmez le nouveau PIN';
    }
  }

  String get _subtitle {
    switch (_step) {
      case _ChangePinStep.current:
        return 'Entrez votre code PIN actuel';
      case _ChangePinStep.create:
        return 'Choisissez un nouveau code à 4 chiffres';
      case _ChangePinStep.confirm:
        return 'Ressaisissez le nouveau code pour le confirmer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(changePinControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Changer le PIN')),
      body: SafeArea(
        child: ResponsiveBody(
          child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(title: _title, subtitle: _subtitle),
              const SizedBox(height: AppDimens.spaceXl),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                CodeInputField(
                  key: ValueKey(_step),
                  length: 4,
                  obscure: true,
                  onChanged: _handleChanged,
                ),
              if (_error != null) ...[
                const SizedBox(height: AppDimens.spaceSm),
                Text(
                  _error!,
                  style: AppTextStyles.caption(context)
                      .copyWith(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
          ),
        ),
      ),
    );
  }
}
