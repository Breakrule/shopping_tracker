import '../entities/item.dart';
import '../entities/shopping_list.dart';

/// Responsibility: Abstract interface for data access.
/// Why: Allows swapping Hive with another storage without affecting domain/presentation.

abstract class ShoppingRepository {
  Future<List<ShoppingList>> getLists();
  Future<void> createList(ShoppingList list);
  Future<void> deleteList(String listId);

  Future<List<Item>> getItemsByList(String listId);
  Future<void> addItem(Item item);
  Future<void> updateItem(Item item);
  Future<void> deleteItem(String itemId);
  Future<List<Item>> getAllItemsHistory(String itemName);
  Future<List<String>> getUniqueItemNames(String query);
  Future<Item?> getLastItemDetails(String itemName);
}
