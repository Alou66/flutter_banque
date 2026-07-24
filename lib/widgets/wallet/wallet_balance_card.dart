import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/wallet.dart';
import '../../utils/formatters.dart';

/// Carte Wallet moderne affichant le solde disponible, avec un dégradé de
/// marque et une option pour masquer le montant.
class WalletBalanceCard extends StatefulWidget {
  const WalletBalanceCard({super.key, required this.wallet});

  final Wallet wallet;

  @override
  State<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<WalletBalanceCard> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDimens.animationNormal,
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Solde disponible',
                style: AppTextStyles.bodySecondary(context)
                    .copyWith(color: AppColors.textOnPrimary.withValues(alpha: 0.8)),
              ),
              IconButton(
                onPressed: () => setState(() => _isHidden = !_isHidden),
                icon: Icon(
                  _isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            _isHidden ? '•••••• FCFA' : Formatters.amount(widget.wallet.balance),
            style: AppTextStyles.displayLarge.copyWith(color: AppColors.textOnPrimary),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined,
                  color: AppColors.textOnPrimary, size: 18),
              const SizedBox(width: AppDimens.spaceXs),
              Text(
                'Compte N° ${widget.wallet.accountNumber}',
                style: AppTextStyles.caption(context)
                    .copyWith(color: AppColors.textOnPrimary.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
