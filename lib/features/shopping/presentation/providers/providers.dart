import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/item_model.dart';
import '../../data/models/shopping_list_model.dart';
import '../../data/repositories/shopping_repository_impl.dart';
import '../../domain/repositories/shopping_repository.dart';

/// Responsibility: Global provider definitions.
/// Why: Centralizes dependency injection.
export 'usecase_providers.dart';

final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  return ShoppingRepositoryImpl(
    listBox: Hive.box<ShoppingListModel>('shopping_lists'),
    itemBox: Hive.box<ItemModel>('items'),
  );
});
