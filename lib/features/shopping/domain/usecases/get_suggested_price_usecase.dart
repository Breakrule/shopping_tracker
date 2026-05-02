import '../repositories/shopping_repository.dart';

class GetSuggestedPriceUseCase {
  final ShoppingRepository _repository;

  GetSuggestedPriceUseCase(this._repository);

  Future<double?> execute(String itemName) async {
    if (itemName.trim().isEmpty) return null;
    
    final history = await _repository.getAllItemsHistory(itemName);
    if (history.isEmpty) return null;
    
    // Return the price of the most recent item (last in list)
    return history.last.price;
  }
}
