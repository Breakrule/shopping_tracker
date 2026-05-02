import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/shopping_list.dart';
import 'providers.dart';

/// Responsibility: State management for the list of shopping lists.
/// Why: Provides reactive updates to the UI.

class ShoppingListNotifier extends AsyncNotifier<List<ShoppingList>> {
  @override
  FutureOr<List<ShoppingList>> build() {
    return _fetchLists();
  }

  Future<List<ShoppingList>> _fetchLists() async {
    final repository = ref.read(shoppingRepositoryProvider);
    final lists = await repository.getLists();
    // Sort by creation date descending
    lists.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return lists;
  }

  Future<void> createList(String name, {double? targetBudget}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(createListUseCaseProvider);
      await useCase.execute(name, targetBudget: targetBudget);
      return _fetchLists();
    });
  }

  Future<void> deleteList(String listId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(shoppingRepositoryProvider);
      await repository.deleteList(listId);
      return _fetchLists();
    });
  }
}

final shoppingListProvider =
    AsyncNotifierProvider<ShoppingListNotifier, List<ShoppingList>>(() {
  return ShoppingListNotifier();
});
