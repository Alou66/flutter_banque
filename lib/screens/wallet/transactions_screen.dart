import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimens.dart';
import '../../providers/transaction_history_controller.dart';
import '../../providers/transaction_query_controller.dart';
import '../../routes/route_paths.dart';
import '../../widgets/common/empty_state_view.dart';
import '../../widgets/common/error_state_view.dart';
import '../../widgets/common/responsive_body.dart';
import '../../widgets/wallet/transaction_filter_chips.dart';
import '../../widgets/wallet/transaction_search_field.dart';
import '../../widgets/wallet/transaction_sort_menu.dart';
import '../../widgets/wallet/transaction_tile.dart';
import '../../widgets/wallet/transaction_tile_skeleton.dart';

/// Historique complet des transactions : recherche, filtre, tri, pagination
/// et pull-to-refresh.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(transactionHistoryControllerProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(transactionQueryControllerProvider);
    final queryNotifier = ref.read(transactionQueryControllerProvider.notifier);
    final historyState = ref.watch(transactionHistoryControllerProvider);
    final historyNotifier = ref.read(transactionHistoryControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spaceLg,
                AppDimens.spaceMd,
                AppDimens.spaceLg,
                0,
              ),
              child: TransactionSearchField(onChanged: queryNotifier.setSearchText),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceMd,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TransactionFilterChips(
                      selected: query.type,
                      onChanged: queryNotifier.setType,
                    ),
                  ),
                  TransactionSortMenu(
                    sortBy: query.sortBy,
                    sortOrder: query.sortOrder,
                    onChanged: queryNotifier.setSort,
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: AppDimens.animationNormal,
                child: historyState.when(
                  data: (data) {
                    if (data.transactions.isEmpty) {
                      return const EmptyStateView(
                        key: ValueKey('history-empty'),
                        icon: Icons.receipt_long_outlined,
                        message: 'Aucune transaction ne correspond à ces critères.',
                      );
                    }
                    return RefreshIndicator(
                      key: const ValueKey('history-data'),
                      onRefresh: historyNotifier.refresh,
                      child: ResponsiveBody(
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.spaceLg,
                          ),
                          itemCount:
                              data.transactions.length + (data.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= data.transactions.length) {
                              return const Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
                                child: TransactionTileSkeleton(),
                              );
                            }
                            final transaction = data.transactions[index];
                            return InkWell(
                              onTap: () => context.push(
                                RoutePaths.transactionDetail,
                                extra: transaction,
                              ),
                              child: TransactionTile(transaction: transaction),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  loading: () => ListView.builder(
                    key: const ValueKey('history-loading'),
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
                    itemCount: 6,
                    itemBuilder: (context, index) => const TransactionTileSkeleton(),
                  ),
                  error: (error, _) => ErrorStateView(
                    key: const ValueKey('history-error'),
                    message: error.toString(),
                    onRetry: historyNotifier.refresh,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
