import 'package:uuid/uuid.dart';
import '../entities/item.dart';
import '../entities/shopping_list.dart';
import '../repositories/shopping_repository.dart';

class SeedDataUseCase {
  final ShoppingRepository repository;

  SeedDataUseCase(this.repository);

  Future<void> execute() async {
    final uuid = const Uuid();
    
    // List 1: Monthly Groceries
    final list1Id = uuid.v4();
    final list1 = ShoppingList(
      id: list1Id,
      name: 'Monthly Groceries',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      targetBudget: 1500000,
    );
    await repository.createList(list1);
    
    final items1 = [
      Item(id: uuid.v4(), listId: list1Id, name: 'Cooking Oil 2L', quantity: 2, price: 35000, isPurchased: true, category: 'Groceries'),
      Item(id: uuid.v4(), listId: list1Id, name: 'Rice 5kg', quantity: 1, price: 75000, isPurchased: true, category: 'Groceries'),
      Item(id: uuid.v4(), listId: list1Id, name: 'Chicken Breast', quantity: 3, price: 45000, isPurchased: false, category: 'Groceries'),
      Item(id: uuid.v4(), listId: list1Id, name: 'Detergent', quantity: 1, price: 28000, isPurchased: true, category: 'Household'),
      Item(id: uuid.v4(), listId: list1Id, name: 'Shampoo', quantity: 1, price: 32000, isPurchased: false, category: 'Personal'),
    ];
    for (var item in items1) {
      await repository.addItem(item);
    }

    // List 2: Weekend Party
    final list2Id = uuid.v4();
    final list2 = ShoppingList(
      id: list2Id,
      name: 'Weekend BBQ Party',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      targetBudget: 500000,
    );
    await repository.createList(list2);
    
    final items2 = [
      Item(id: uuid.v4(), listId: list2Id, name: 'Beef Grill', quantity: 2, price: 120000, isPurchased: true, category: 'Groceries'),
      Item(id: uuid.v4(), listId: list2Id, name: 'Charcoal', quantity: 1, price: 15000, isPurchased: true, category: 'Other'),
      Item(id: uuid.v4(), listId: list2Id, name: 'Soda 1.5L', quantity: 4, price: 12000, isPurchased: false, category: 'Groceries'),
    ];
    for (var item in items2) {
      await repository.addItem(item);
    }
  }
}
