import 'package:uuid/uuid.dart';
import '../entities/item.dart';
import '../repositories/shopping_repository.dart';

/// Responsibility: Business logic for adding an item to a list.
/// Why: Centralizes validation and ID generation.

class AddItemUseCase {
  final ShoppingRepository _repository;
  final _uuid = const Uuid();

  AddItemUseCase(this._repository);

  Future<void> execute({
    required String listId,
    required String name,
    int quantity = 1,
    double? price,
    String category = 'Other',
  }) async {
    if (name.trim().isEmpty) {
      throw Exception('Item name cannot be empty');
    }
    if (quantity < 1) {
      throw Exception('Quantity must be at least 1');
    }

    final newItem = Item(
      id: _uuid.v4(),
      listId: listId,
      name: name.trim(),
      quantity: quantity,
      price: price,
      isPurchased: false,
      category: category,
    );

    await _repository.addItem(newItem);
  }
}
