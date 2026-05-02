import '../entities/item.dart';
import '../repositories/shopping_repository.dart';

/// Responsibility: Business logic for toggling the purchased status of an item.

class ToggleItemPurchasedUseCase {
  final ShoppingRepository _repository;

  ToggleItemPurchasedUseCase(this._repository);

  Future<void> execute(Item item) async {
    final updatedItem = item.copyWith(isPurchased: !item.isPurchased);
    await _repository.updateItem(updatedItem);
  }
}
