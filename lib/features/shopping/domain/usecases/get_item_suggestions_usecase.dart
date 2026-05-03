import '../repositories/shopping_repository.dart';

class GetItemSuggestionsUseCase {
  final ShoppingRepository _repository;

  GetItemSuggestionsUseCase(this._repository);

  Future<List<String>> execute(String query) {
    return _repository.getUniqueItemNames(query);
  }
}
