import 'package:uuid/uuid.dart';
import '../entities/shopping_list.dart';
import '../repositories/shopping_repository.dart';

/// Responsibility: Business logic for creating a new shopping list.
/// Why: Centralizes validation and ID generation.

class CreateListUseCase {
  final ShoppingRepository _repository;
  final _uuid = const Uuid();

  CreateListUseCase(this._repository);

  Future<void> execute(String name, {double? targetBudget}) async {
    if (name.trim().isEmpty) {
      throw Exception('List name cannot be empty');
    }

    final newList = ShoppingList(
      id: _uuid.v4(),
      name: name.trim(),
      createdAt: DateTime.now(),
      targetBudget: targetBudget,
    );

    await _repository.createList(newList);
  }
}
