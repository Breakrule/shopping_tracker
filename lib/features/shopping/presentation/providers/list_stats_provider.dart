import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class ListStats {
  final int totalItems;
  final int completedItems;
  final double totalSpent;

  ListStats({
    required this.totalItems,
    required this.completedItems,
    required this.totalSpent,
  });

  double get progress => totalItems == 0 ? 0 : completedItems / totalItems;
}

final listStatsProvider = FutureProvider.family<ListStats, String>((ref, listId) async {
  final repository = ref.read(shoppingRepositoryProvider);
  final items = await repository.getItemsByList(listId);
  
  final totalItems = items.length;
  final completedItems = items.where((i) => i.isPurchased).length;
  final totalSpent = items.where((i) => i.isPurchased).fold(0.0, (sum, i) => sum + (i.price ?? 0) * i.quantity);

  return ListStats(
    totalItems: totalItems,
    completedItems: completedItems,
    totalSpent: totalSpent,
  );
});
