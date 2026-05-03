import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:intl/intl.dart';
import 'package:monthly_shop_tracker/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:monthly_shop_tracker/core/theme/app_colors.dart';
import '../../domain/entities/item.dart';
import '../providers/items_notifier.dart';
import '../providers/providers.dart';
import '../providers/shopping_list_notifier.dart';
import '../widgets/add_item_modal.dart';
import '../widgets/spending_donut_chart.dart';

/// Responsibility: Display items in a specific list, always grouped by category.

class ListDetailScreen extends ConsumerStatefulWidget {
  final String listId;
  final String listName;

  const ListDetailScreen({
    super.key,
    required this.listId,
    required this.listName,
  });

  @override
  ConsumerState<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends ConsumerState<ListDetailScreen> {
  late ConfettiController _confettiController;
  bool _wasCompleted = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemsProvider(widget.listId));
    final total = ref.read(itemsProvider(widget.listId).notifier).calculateTotal();
    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final items = itemsAsync.valueOrNull ?? [];
    final stats = ref.read(calculateCategoryStatsUseCaseProvider).execute(items);

    if (items.isNotEmpty) {
      final isCompleted = items.every((i) => i.isPurchased);
      if (isCompleted && !_wasCompleted) {
        _confettiController.play();
        _wasCompleted = true;
      } else if (!isCompleted) {
        _wasCompleted = false;
      }
    }

    final lists = ref.watch(shoppingListProvider).valueOrNull ?? [];
    final currentList = lists.firstWhere((l) => l.id == widget.listId);
    final budget = currentList.targetBudget;
    final isOverBudget = budget != null && total > budget;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.insights_rounded, size: 24),
                onPressed: () => _showStats(context, stats, currencyFormatter, total),
                tooltip: AppLocalizations.of(context)!.insights,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.ios_share_rounded, size: 24),
                  onPressed: () {
                    final text = ref.read(exportListUseCaseProvider).execute(widget.listName, items, total);
                    final box = context.findRenderObject() as RenderBox?;
                    SharePlus.instance.share(
                      ShareParams(
                        text: text,
                        sharePositionOrigin: box != null
                            ? box.localToGlobal(Offset.zero) & box.size
                            : null,
                      ),
                    );
                  },
                  tooltip: 'Share List',
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.listName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isOverBudget
                              ? Colors.redAccent.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          currencyFormatter.format(total),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isOverBudget ? Colors.redAccent : Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      if (budget != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          '/ ${currencyFormatter.format(budget)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -20,
                    left: -20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .move(duration: 4.seconds, begin: const Offset(0, 0), end: const Offset(30, 30))
                     .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3)),
                  ),
                  Center(
                    child: Opacity(
                      opacity: 0.1,
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 140,
                        color: Colors.white,
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .rotate(duration: 10.seconds, begin: -0.05, end: 0.05),
                  ),
                ],
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          if (items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 80,
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                     .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.1, 1.1))
                     .then()
                     .moveY(begin: 0, end: -10, duration: 2.seconds),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)!.noItemsYet,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        AppLocalizations.of(context)!.noItemsSub,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final grouped = <String, List<Item>>{};
                    for (final item in items) {
                      grouped.putIfAbsent(item.category, () => []).add(item);
                    }
                    final flattenedList = <dynamic>[];
                    grouped.forEach((category, categoryItems) {
                      flattenedList.add(category);
                      flattenedList.addAll(categoryItems);
                    });
                    if (index >= flattenedList.length) return null;
                    final element = flattenedList[index];
                    if (element is String) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.getCategoryColor(element).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.getCategoryColor(element).withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: AppColors.getCategoryColor(element),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      element.toUpperCase(),
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: AppColors.getCategoryColor(element),
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                          ),
                        ),
                      );
                    }
                    final item = element as Item;
                    return _buildItemTile(context, item, theme, currencyFormatter, index);
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddItemModal(context, widget.listId),
        child: const Icon(Icons.add, size: 28),
      ),
      extendBody: true,
      bottomNavigationBar: Align(
        alignment: Alignment.topCenter,
        heightFactor: 0,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
        ),
      ),
    );
  }

  void _showPriceHistory(BuildContext context, WidgetRef ref, String itemName) async {
    final theme = Theme.of(context);
    final repository = ref.read(shoppingRepositoryProvider);
    final history = await repository.getAllItemsHistory(itemName);
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Price History: $itemName'),
        content: history.isEmpty
            ? const Text('No price history found.')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(formatter.format(item.price)),
                      subtitle: Text('Qty: ${item.quantity}'),
                      trailing: const Icon(Icons.history, size: 16, color: Colors.grey),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showStats(BuildContext context, Map<String, double> stats, NumberFormat formatter, double total) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.insights, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Breakdown by category', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            if (stats.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 32), child: Text('No purchased items to analyze.')))
            else ...[
              Center(child: SpendingDonutChart(stats: stats, total: total)),
              const SizedBox(height: 32),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: stats.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final category = stats.keys.elementAt(index);
                    final amount = stats[category]!;
                    final percentage = total > 0 ? (amount / total) : 0.0;
                    final color = AppColors.getCategoryColor(category);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                Text(category, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Text(formatter.format(amount), style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: color.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('${(percentage * 100).toStringAsFixed(1)}% of total', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      ],
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmDeleteItem(BuildContext context, String itemId) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context)!.delete),
        content: const Text('Are you sure you want to remove this item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              ref.read(itemsProvider(widget.listId).notifier).deleteItem(itemId);
              Navigator.pop(context, true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, Item item, ThemeData theme, NumberFormat currencyFormatter, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) => _confirmDeleteItem(context, item.id),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.delete_outline, color: Colors.white),
        ),
        child: InkWell(
          onLongPress: () => _showPriceHistory(context, ref, item.name),
          borderRadius: BorderRadius.circular(16),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.05)),
            ),
            color: item.isPurchased ? theme.cardColor.withValues(alpha: 0.6) : theme.cardColor,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Checkbox(
                value: item.isPurchased,
                activeColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (_) {
                  HapticFeedback.selectionClick();
                  ref.read(itemsProvider(widget.listId).notifier).togglePurchased(item);
                },
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: item.isPurchased ? TextDecoration.lineThrough : null,
                        color: item.isPurchased ? Colors.grey : theme.textTheme.titleMedium?.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ).animate(target: item.isPurchased ? 1 : 0)
                     .shimmer(duration: 400.ms, color: theme.colorScheme.primary.withValues(alpha: 0.2))
                     .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 200.ms, curve: Curves.easeOut),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 14, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text('${item.quantity}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                    if (item.price != null) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.payments_outlined, size: 14, color: Colors.grey.withValues(alpha: 0.7)),
                      const SizedBox(width: 4),
                      Text(currencyFormatter.format(item.price), style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate(delay: (index * 50).ms).fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
