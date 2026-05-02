import 'package:hive/hive.dart';
import '../../domain/entities/shopping_list.dart';

part 'shopping_list_model.g.dart';

/// Responsibility: Hive-serializable model for ShoppingList.
/// Why: Isolates Hive annotations from the domain entity.

@HiveType(typeId: 0)
class ShoppingListModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime createdAt;

  ShoppingListModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory ShoppingListModel.fromEntity(ShoppingList entity) {
    return ShoppingListModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
    );
  }

  ShoppingList toEntity() {
    return ShoppingList(
      id: id,
      name: name,
      createdAt: createdAt,
    );
  }
}
