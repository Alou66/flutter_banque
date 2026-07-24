import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/session_controller.dart';
import '../../providers/wallet_dashboard_controller.dart';
import '../../routes/route_paths.dart';
import '../../widgets/common/error_state_view.dart';
import '../../widgets/common/responsive_body.dart';
import '../../widgets/wallet/profile_header.dart';
import '../../widgets/wallet/quick_action_button.dart';
import '../../widgets/wallet/transaction_tile.dart';
import '../../widgets/wallet/wallet_balance_card.dart';
import '../../widgets/wallet/wallet_dashboard_skeleton.dart';

/// Écran d'accueil après authentification : profil, solde, actions rapides
/// et aperçu des dernières transactions.
class WalletDashboardScreen extends ConsumerWidget {
  const WalletDashboardScreen({super.key});

  void _logout(WidgetRef ref, BuildContext context) {
    ref.read(sessionControllerProvider.notifier).clear();
    ref.read(sessionTokenControllerProvider.notifier).clear();
    context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(walletDashboardControllerProvider);
    final user = ref.watch(sessionControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: AppDimens.animationNormal,
          child: dashboardState.when(
            data: (data) {
              if (user == null) return const SizedBox.shrink();
              return RefreshIndicator(
                key: const ValueKey('dashboard-data'),
                onRefresh: () => ref
                    .read(walletDashboardControllerProvider.notifier)
                    .refresh(),
                child: ResponsiveBody(
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppDimens.spaceLg),
                    children: [
                      ProfileHeader(
                        user: user,
                        onLogout: () => _logout(ref, context),
                        onTap: () => context.push(RoutePaths.profile),
                      ),
                      const SizedBox(height: AppDimens.spaceLg),
                      WalletBalanceCard(wallet: data.wallet),
                      const SizedBox(height: AppDimens.spaceLg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          QuickActionButton(
                            icon: Icons.add_circle_outline,
                            label: 'Dépôt',
                            onTap: () => context.push(RoutePaths.deposit),
                          ),
                          QuickActionButton(
                            icon: Icons.remove_circle_outline,
                            label: 'Retrait',
                            onTap: () => context.push(RoutePaths.withdraw),
                          ),
                          QuickActionButton(
                            icon: Icons.send_outlined,
                            label: 'Paiement',
                            onTap: () => context.push(RoutePaths.payment),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.spaceXl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Transactions récentes',
                              style: AppTextStyles.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push(RoutePaths.transactions),
                            child: const Text('Voir tout'),
                          ),
                        ],
                      ),
                      if (data.transactions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimens.spaceLg,
                          ),
                          child: Text(
                            'Aucune transaction récente.',
                            style: AppTextStyles.bodySecondary(context),
                          ),
                        )
                      else
                        ...data.transactions
                            .map((t) => TransactionTile(transaction: t)),
                    ],
                  ),
                ),
              );
            },
            loading: () => const WalletDashboardSkeleton(
              key: ValueKey('dashboard-loading'),
            ),
            error: (error, _) => ErrorStateView(
              key: const ValueKey('dashboard-error'),
              message: error.toString(),
              onRetry: () =>
                  ref.read(walletDashboardControllerProvider.notifier).refresh(),
            ),
          ),
        ),
      ),
    );
  }
}
