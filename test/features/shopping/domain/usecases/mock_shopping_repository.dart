import 'package:monthly_shop_tracker/features/shopping/domain/entities/item.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/entities/shopping_list.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/repositories/shopping_repository.dart';

class MockShoppingRepository implements ShoppingRepository {
  final List<ShoppingList> lists = [];
  final List<Item> items = [];

  @override
  Future<void> createList(ShoppingList list) async {
    lists.add(list);
  }

  @override
  Future<void> deleteList(String listId) async {
    lists.removeWhere((l) => l.id == listId);
    items.removeWhere((i) => i.listId == listId);
  }

  @override
  Future<List<ShoppingList>> getLists() async => lists;

  @override
  Future<void> addItem(Item item) async {
    items.add(item);
  }

  @override
  Future<void> deleteItem(String itemId) async {
    items.removeWhere((i) => i.id == itemId);
  }

  @override
  Future<List<Item>> getItemsByList(String listId) async {
    return items.where((i) => i.listId == listId).toList();
  }

  @override
  Future<void> updateItem(Item item) async {
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
    }
  }
}
