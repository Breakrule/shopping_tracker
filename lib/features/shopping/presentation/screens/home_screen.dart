import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:monthly_shop_tracker/l10n/app_localizations.dart';
import '../../domain/entities/shopping_list.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../providers/list_stats_provider.dart';
import '../providers/shopping_list_notifier.dart';
import 'list_detail_screen.dart';

/// Responsibility: Display all shopping lists and allow creation of new ones.

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(shoppingListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.settings_rounded, size: 26),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                  tooltip: 'Settings',
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
              title: Text(
                AppLocalizations.of(context)!.homeTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
              background: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -50,
                    right: -20,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF472B6).withValues(alpha: 0.3),
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .move(duration: 5.seconds, begin: const Offset(0, 0), end: const Offset(-50, 50))
                     .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -10,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF60A5FA).withValues(alpha: 0.2),
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .move(duration: 7.seconds, begin: const Offset(0, 0), end: const Offset(40, -40))
                     .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
                  ),
                ],
              ),
            ),
          ),
          ...listsAsync.when(
            data: (lists) {
              if (lists.isEmpty) {
                return [
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
                              Icons.shopping_bag_outlined,
                              size: 80,
                              color: theme.colorScheme.primary.withValues(alpha: 0.5),
                            ),
                          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                           .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.1, 1.1))
                           .then()
                           .moveY(begin: 0, end: -10, duration: 2.seconds),
                          const SizedBox(height: 32),
                          Text(
                            AppLocalizations.of(context)!.noListsYet,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            child: Text(
                              AppLocalizations.of(context)!.noListsSub,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5),
                            ),
                          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    ),
                  )
                ];
              }
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Row(
                      children: [
                        Text(
                          'Your Activity',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${lists.length} lists',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final list = lists[index];
                        final statsAsync = ref.watch(listStatsProvider(list.id));
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Dismissible(
                            key: Key(list.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) => _confirmDelete(context, ref, list.id),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 32),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 32),
                            ),
                            child: Hero(
                              tag: 'list_card_${list.id}',
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListDetailScreen(
                                          listId: list.id,
                                          listName: list.name,
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () => _showListOptions(context, ref, list),
                                  borderRadius: BorderRadius.circular(24),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.cardColor,
                                          theme.cardColor.withValues(alpha: 0.9),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.05),
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            right: -10,
                                            bottom: -10,
                                            child: Icon(
                                              Icons.shopping_basket_rounded,
                                              size: 120,
                                              color: theme.colorScheme.primary.withValues(alpha: 0.03),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(24),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: 48,
                                                          height: 48,
                                                          child: CircularProgressIndicator(
                                                            value: statsAsync.valueOrNull?.progress ?? 0,
                                                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                                                            strokeWidth: 3,
                                                            strokeCap: StrokeCap.round,
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                            color: theme.colorScheme.primary.withValues(alpha: 0.12),
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            Icons.local_mall_rounded,
                                                            color: theme.colorScheme.primary,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: IconButton(
                                                        padding: EdgeInsets.zero,
                                                        constraints: const BoxConstraints(),
                                                        icon: const Icon(Icons.more_horiz_rounded, color: Colors.grey),
                                                        onPressed: () => _showListOptions(context, ref, list),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  list.name,
                                                  style: theme.textTheme.titleLarge?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      DateFormat('MMM dd, yyyy').format(list.createdAt.toLocal()),
                                                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                                    ),
                                                    const Spacer(),
                                                    statsAsync.when(
                                                      data: (stats) => Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          '${stats.completedItems}/${stats.totalItems} ${AppLocalizations.of(context)!.items}',
                                                          style: theme.textTheme.labelSmall?.copyWith(
                                                            color: theme.colorScheme.primary,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      loading: () => const SizedBox.shrink(),
                                                      error: (_, stack) => const SizedBox.shrink(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ).animate(delay: (index * 100).ms)
                           .fadeIn(duration: 500.ms)
                           .slideY(begin: 0.3, end: 0, curve: Curves.easeOutQuad),
                        );
                      },
                      childCount: lists.length,
                    ),
                  ),
                ),
              ];
            },
            loading: () => [
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            ],
            error: (err, stack) => [
              SliverFillRemaining(
                child: Center(child: Text('Error: $err')),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  void _showListOptions(BuildContext context, WidgetRef ref, ShoppingList list) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
            title: Text(AppLocalizations.of(context)!.deleteList, style: const TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(context, ref, list.id);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context)!.addList),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter list name',
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: budgetController,
              decoration: InputDecoration(
                hintText: 'Target Budget (Optional)',
                filled: true,
                fillColor: Colors.black12,
                prefixText: 'Rp ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                HapticFeedback.heavyImpact();
                ref.read(shoppingListProvider.notifier).createList(
                      nameController.text,
                      targetBudget: double.tryParse(budgetController.text),
                    );
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.create),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, WidgetRef ref, String listId) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context)!.deleteList),
        content: Text(AppLocalizations.of(context)!.deleteListConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              ref.read(shoppingListProvider.notifier).deleteList(listId);
              Navigator.pop(context, true);
            },
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}
