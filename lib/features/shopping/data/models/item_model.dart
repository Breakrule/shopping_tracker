import 'package:hive/hive.dart';
import '../../domain/entities/item.dart';

part 'item_model.g.dart';

/// Responsibility: Hive-serializable model for Item.
/// Why: Isolates Hive annotations from the domain entity.

@HiveType(typeId: 1)
class ItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String listId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final double? price;

  @HiveField(5)
  final bool isPurchased;

  ItemModel({
    required this.id,
    required this.listId,
    required this.name,
    required this.quantity,
    this.price,
    required this.isPurchased,
  });

  factory ItemModel.fromEntity(Item entity) {
    return ItemModel(
      id: entity.id,
      listId: entity.listId,
      name: entity.name,
      quantity: entity.quantity,
      price: entity.price,
      isPurchased: entity.isPurchased,
    );
  }

  Item toEntity() {
    return Item(
      id: id,
      listId: listId,
      name: name,
      quantity: quantity,
      price: price,
      isPurchased: isPurchased,
    );
  }
}
