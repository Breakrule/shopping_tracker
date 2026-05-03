import '../repositories/shopping_repository.dart';

class ItemDefaults {
  final String? category;
  final double? suggestedPrice;

  ItemDefaults({this.category, this.suggestedPrice});
}

class GetItemDefaultsUseCase {
  final ShoppingRepository _repository;

  GetItemDefaultsUseCase(this._repository);

  Future<ItemDefaults> execute(String itemName) async {
    final lastItem = await _repository.getLastItemDetails(itemName);
    
    return ItemDefaults(
      category: lastItem?.category,
      suggestedPrice: lastItem?.price,
    );
  }
}
