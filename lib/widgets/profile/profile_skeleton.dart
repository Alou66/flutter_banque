import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../common/shimmer_box.dart';

/// Silhouette de l'écran Profil, affichée pendant le chargement.
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      children: const [
        _InfoLineSkeleton(),
        SizedBox(height: AppDimens.spaceMd),
        _InfoLineSkeleton(),
        SizedBox(height: AppDimens.spaceMd),
        _InfoLineSkeleton(),
        SizedBox(height: AppDimens.spaceLg),
        ShimmerBox(height: 52, borderRadius: AppDimens.radiusMd),
        SizedBox(height: AppDimens.spaceSm),
        ShimmerBox(height: 52, borderRadius: AppDimens.radiusMd),
        SizedBox(height: AppDimens.spaceSm),
        ShimmerBox(height: 52, borderRadius: AppDimens.radiusMd),
      ],
    );
  }
}

class _InfoLineSkeleton extends StatelessWidget {
  const _InfoLineSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ShimmerBox(width: 24, height: 24, borderRadius: 6),
        const SizedBox(width: AppDimens.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerBox(width: 60, height: 10),
              SizedBox(height: AppDimens.spaceXs),
              ShimmerBox(width: 140, height: 14),
            ],
          ),
        ),
      ],
    );
  }
}
