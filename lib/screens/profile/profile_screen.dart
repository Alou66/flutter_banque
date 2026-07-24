import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../providers/profile_controller.dart';
import '../../providers/session_controller.dart';
import '../../routes/route_paths.dart';
import '../../widgets/common/error_state_view.dart';
import '../../widgets/common/responsive_body.dart';
import '../../widgets/profile/profile_info_tile.dart';
import '../../widgets/profile/profile_skeleton.dart';

/// Écran Profil : informations utilisateur et accès aux actions du compte.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(WidgetRef ref, BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    ref.read(sessionControllerProvider.notifier).clear();
    ref.read(sessionTokenControllerProvider.notifier).clear();
    if (context.mounted) context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: AppDimens.animationNormal,
          child: profileState.when(
            data: (user) => ResponsiveBody(
              key: const ValueKey('profile-data'),
              child: ListView(
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                children: [
                  ProfileInfoTile(
                    icon: Icons.badge_outlined,
                    label: 'Prénom',
                    value: user.firstName,
                  ),
                  ProfileInfoTile(
                    icon: Icons.badge_outlined,
                    label: 'Nom',
                    value: user.lastName,
                  ),
                  ProfileInfoTile(
                    icon: Icons.phone_outlined,
                    label: 'Téléphone',
                    value: user.phoneNumber,
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  OutlinedButton.icon(
                    onPressed: () => context.push(RoutePaths.profileEdit),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Modifier le profil'),
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  OutlinedButton.icon(
                    onPressed: () => context.push(RoutePaths.profileChangePin),
                    icon: const Icon(Icons.lock_outline),
                    label: const Text('Changer le PIN'),
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  OutlinedButton.icon(
                    onPressed: () => _logout(ref, context),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Se déconnecter'),
                  ),
                ],
              ),
            ),
            loading: () => const ProfileSkeleton(key: ValueKey('profile-loading')),
            error: (error, _) => ErrorStateView(
              key: const ValueKey('profile-error'),
              message: error.toString(),
              onRetry: () => ref.read(profileControllerProvider.notifier).refresh(),
            ),
          ),
        ),
      ),
    );
  }
}
