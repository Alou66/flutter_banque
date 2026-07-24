import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/registration_data.dart';
import '../../providers/pin_setup_controller.dart';
import '../../routes/route_paths.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/code_input_field.dart';
import '../../widgets/common/responsive_body.dart';

enum _PinStep { create, confirm }

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key, required this.data});

  final RegistrationData data;

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  _PinStep _step = _PinStep.create;
  String _firstPin = '';
  String? _error;

  void _handleChanged(String value) {
    setState(() => _error = null);

    if (value.length != 4) return;

    if (_step == _PinStep.create) {
      setState(() {
        _firstPin = value;
        _step = _PinStep.confirm;
      });
      return;
    }

    if (value == _firstPin) {
      _confirmPin();
    } else {
      setState(() {
        _error = 'Les codes PIN ne correspondent pas. Réessayez.';
        _step = _PinStep.create;
        _firstPin = '';
      });
    }
  }

  Future<void> _confirmPin() async {
    await ref.read(pinSetupControllerProvider.notifier).createPin(
          data: widget.data,
          pin: _firstPin,
        );

    if (!mounted) return;
    final state = ref.read(pinSetupControllerProvider);
    if (state.hasValue && state.value != null) {
      context.go(RoutePaths.home);
    } else if (state.hasError) {
      setState(() {
        _error = state.error.toString();
        _step = _PinStep.create;
        _firstPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(pinSetupControllerProvider).isLoading;
    final isConfirmStep = _step == _PinStep.confirm;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ResponsiveBody(
          child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: isConfirmStep ? 'Confirmez le PIN' : 'Créez un code PIN',
                subtitle: isConfirmStep
                    ? 'Ressaisissez votre code pour le confirmer'
                    : 'Ce code protégera votre compte',
              ),
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
