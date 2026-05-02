/// Responsibility: Pure domain entity for a Shopping List.
/// Why: Decouples business logic from persistence framework (Hive).
/// Tradeoff: Requires mapping to/from Hive models in the data layer.
library;

class ShoppingList {
  final String id;
  final String name;
  final DateTime createdAt;
  final double? targetBudget;

  ShoppingList({
    required this.id,
    required this.name,
    required this.createdAt,
    this.targetBudget,
  });

  ShoppingList copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    double? targetBudget,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      targetBudget: targetBudget ?? this.targetBudget,
    );
  }
}
