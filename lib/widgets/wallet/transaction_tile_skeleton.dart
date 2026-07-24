import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../common/shimmer_box.dart';

/// Silhouette d'une [TransactionTile], affichée pendant le chargement.
class TransactionTileSkeleton extends StatelessWidget {
  const TransactionTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      child: Row(
        children: [
          const ShimmerBox(width: 44, height: 44, borderRadius: 22),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(width: 140, height: 14),
                SizedBox(height: AppDimens.spaceXs),
                ShimmerBox(width: 80, height: 12),
              ],
            ),
          ),
          const ShimmerBox(width: 64, height: 14),
        ],
      ),
    );
  }
}
