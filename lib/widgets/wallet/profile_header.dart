import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors_extension.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/auth_user.dart';

/// En-tête du Dashboard : avatar, nom et téléphone de l'utilisateur connecté.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    this.onLogout,
    this.onTap,
  });

  final AuthUser user;
  final VoidCallback? onLogout;
  final VoidCallback? onTap;

  String get _initials {
    final first = user.firstName.isNotEmpty ? user.firstName[0] : '';
    final last = user.lastName.isNotEmpty ? user.lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    _initials,
                    style: AppTextStyles.title
                        .copyWith(color: AppColors.textOnPrimary),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: AppTextStyles.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.phoneNumber,
                        style: AppTextStyles.bodySecondary(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (onLogout != null)
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
            color: context.appColors.textSecondary,
            tooltip: 'Se déconnecter',
          ),
      ],
    );
  }
}
