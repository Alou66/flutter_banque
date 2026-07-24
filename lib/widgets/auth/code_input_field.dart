import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors_extension.dart';
import '../../core/theme/app_text_styles.dart';

/// Saisie de code par cases (OTP ou PIN), réutilisable sur plusieurs écrans.
class CodeInputField extends StatefulWidget {
  const CodeInputField({
    super.key,
    required this.length,
    required this.onChanged,
    this.controller,
    this.obscure = false,
    this.autofocus = true,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final bool obscure;
  final bool autofocus;

  @override
  State<CodeInputField> createState() => _CodeInputFieldState();
}

class _CodeInputFieldState extends State<CodeInputField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: SizedBox(
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(widget.length, _buildBox),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: widget.autofocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.length),
                  ],
                  onChanged: (value) {
                    widget.onChanged(value);
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(int index) {
    final text = _controller.text;
    final isActive = index == text.length;
    final char = index < text.length ? text[index] : '';

    return Container(
      width: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(
          color: isActive ? AppColors.primary : context.appColors.border,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Text(
        char.isEmpty ? '' : (widget.obscure ? '•' : char),
        style: AppTextStyles.headline,
      ),
    );
  }
}
