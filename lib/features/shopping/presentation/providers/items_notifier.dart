import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/item.dart';
import 'providers.dart';

/// Responsibility: State management for items within a specific shopping list.
/// Why: Family provider allows scoping state to a listId.

class ItemsNotifier extends FamilyAsyncNotifier<List<Item>, String> {
  @override
  FutureOr<List<Item>> build(String arg) {
    return _fetchItems(arg);
  }

  Future<List<Item>> _fetchItems(String listId) async {
    final repository = ref.read(shoppingRepositoryProvider);
    return await repository.getItemsByList(listId);
  }

  Future<void> addItem({
    required String name,
    int quantity = 1,
    double? price,
    String category = 'Other',
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(addItemUseCaseProvider);
      await useCase.execute(
        listId: arg,
        name: name,
        quantity: quantity,
        price: price,
        category: category,
      );
      return _fetchItems(arg);
    });
  }

  Future<void> togglePurchased(Item item) async {
    // Optimistic update could be done here, but keeping it simple for MVP
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(toggleItemPurchasedUseCaseProvider);
      await useCase.execute(item);
      return _fetchItems(arg);
    });
  }

  Future<void> deleteItem(String itemId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(shoppingRepositoryProvider);
      await repository.deleteItem(itemId);
      return _fetchItems(arg);
    });
  }

  double calculateTotal() {
    if (state.value == null) return 0.0;
    final useCase = ref.read(calculateTotalUseCaseProvider);
    return useCase.execute(state.value!);
  }
}

final itemsProvider =
    AsyncNotifierProviderFamily<ItemsNotifier, List<Item>, String>(() {
  return ItemsNotifier();
});
