import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/item_model.dart';
import '../../data/models/shopping_list_model.dart';
import '../../data/repositories/shopping_repository_impl.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../../domain/usecases/add_item_usecase.dart';
import '../../domain/usecases/calculate_total_usecase.dart';
import '../../domain/usecases/create_list_usecase.dart';
import '../../domain/usecases/toggle_item_purchased_usecase.dart';

/// Responsibility: Global provider definitions.
/// Why: Centralizes dependency injection.

final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  return ShoppingRepositoryImpl(
    listBox: Hive.box<ShoppingListModel>('shopping_lists'),
    itemBox: Hive.box<ItemModel>('items'),
  );
});

// Use Case Providers
final createListUseCaseProvider = Provider((ref) {
  return CreateListUseCase(ref.watch(shoppingRepositoryProvider));
});

final addItemUseCaseProvider = Provider((ref) {
  return AddItemUseCase(ref.watch(shoppingRepositoryProvider));
});

final toggleItemPurchasedUseCaseProvider = Provider((ref) {
  return ToggleItemPurchasedUseCase(ref.watch(shoppingRepositoryProvider));
});

final calculateTotalUseCaseProvider = Provider((ref) {
  return CalculateTotalUseCase();
});
