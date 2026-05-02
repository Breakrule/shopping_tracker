/// Responsibility: Pure domain entity for a Shopping Item.
/// Why: Decouples business logic from persistence framework (Hive).
/// Tradeoff: Requires mapping to/from Hive models in the data layer.
library;

class Item {
  final String id;
  final String listId;
  final String name;
  final int quantity;
  final double? price;
  final bool isPurchased;

  Item({
    required this.id,
    required this.listId,
    required this.name,
    this.quantity = 1,
    this.price,
    this.isPurchased = false,
  });

  Item copyWith({
    String? id,
    String? listId,
    String? name,
    int? quantity,
    double? price,
    bool? isPurchased,
  }) {
    return Item(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}
