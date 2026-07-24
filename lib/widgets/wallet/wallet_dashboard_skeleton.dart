import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../common/shimmer_box.dart';
import 'transaction_tile_skeleton.dart';

/// Silhouette du Dashboard Wallet, affichée pendant le premier chargement.
class WalletDashboardSkeleton extends StatelessWidget {
  const WalletDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      children: [
        Row(
          children: [
            const ShimmerBox(width: 52, height: 52, borderRadius: 26),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 120, height: 16),
                  SizedBox(height: AppDimens.spaceXs),
                  ShimmerBox(width: 90, height: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceLg),
        ShimmerBox(height: 160, borderRadius: AppDimens.radiusLg),
        const SizedBox(height: AppDimens.spaceLg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            ShimmerBox(width: 56, height: 56, borderRadius: AppDimens.radiusMd),
            ShimmerBox(width: 56, height: 56, borderRadius: AppDimens.radiusMd),
            ShimmerBox(width: 56, height: 56, borderRadius: AppDimens.radiusMd),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXl),
        const ShimmerBox(width: 160, height: 18),
        const SizedBox(height: AppDimens.spaceSm),
        const TransactionTileSkeleton(),
        const TransactionTileSkeleton(),
        const TransactionTileSkeleton(),
      ],
    );
  }
}
