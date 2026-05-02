/// Responsibility: Pure domain entity for a Shopping List.
/// Why: Decouples business logic from persistence framework (Hive).
/// Tradeoff: Requires mapping to/from Hive models in the data layer.
library;

class ShoppingList {
  final String id;
  final String name;
  final DateTime createdAt;

  ShoppingList({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  ShoppingList copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
