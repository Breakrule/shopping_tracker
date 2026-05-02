import 'package:hive/hive.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/shopping_list.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../models/item_model.dart';
import '../models/shopping_list_model.dart';

/// Responsibility: Concrete implementation of ShoppingRepository using Hive.
/// Why: Handles Hive-specific logic and model/entity mapping.

class ShoppingRepositoryImpl implements ShoppingRepository {
  final Box<ShoppingListModel> _listBox;
  final Box<ItemModel> _itemBox;

  ShoppingRepositoryImpl({
    required Box<ShoppingListModel> listBox,
    required Box<ItemModel> itemBox,
  })  : _listBox = listBox,
        _itemBox = itemBox;

  @override
  Future<List<ShoppingList>> getLists() async {
    return _listBox.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createList(ShoppingList list) async {
    final model = ShoppingListModel.fromEntity(list);
    await _listBox.put(list.id, model);
  }

  @override
  Future<void> deleteList(String listId) async {
    await _listBox.delete(listId);
    // Cleanup items associated with this list
    final itemKeysToDelete = _itemBox.values
        .where((item) => item.listId == listId)
        .map((item) => item.id)
        .toList();
    await _itemBox.deleteAll(itemKeysToDelete);
  }

  @override
  Future<List<Item>> getItemsByList(String listId) async {
    return _itemBox.values
        .where((model) => model.listId == listId)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<void> addItem(Item item) async {
    final model = ItemModel.fromEntity(item);
    await _itemBox.put(item.id, model);
  }

  @override
  Future<void> updateItem(Item item) async {
    final model = ItemModel.fromEntity(item);
    await _itemBox.put(item.id, model);
  }

  @override
  Future<void> deleteItem(String itemId) async {
    await _itemBox.delete(itemId);
  }

  @override
  Future<List<Item>> getAllItemsHistory(String itemName) async {
    final searchName = itemName.trim().toLowerCase();
    return _itemBox.values
        .where((m) => m.name.toLowerCase() == searchName && m.price != null)
        .map((m) => m.toEntity())
        .toList();
  }
}
