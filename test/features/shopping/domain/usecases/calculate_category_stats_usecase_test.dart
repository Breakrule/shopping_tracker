import 'package:flutter_test/flutter_test.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/entities/item.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/usecases/calculate_category_stats_usecase.dart';

void main() {
  late CalculateCategoryStatsUseCase useCase;

  setUp(() {
    useCase = CalculateCategoryStatsUseCase();
  });

  test('should calculate stats correctly for purchased items', () {
    final items = [
      Item(id: '1', listId: 'l1', name: 'Milk', quantity: 2, price: 10.0, isPurchased: true, category: 'Food'),
      Item(id: '2', listId: 'l1', name: 'Bread', quantity: 1, price: 5.0, isPurchased: true, category: 'Food'),
      Item(id: '3', listId: 'l1', name: 'Soap', quantity: 3, price: 2.0, isPurchased: true, category: 'Toiletries'),
      Item(id: '4', listId: 'l1', name: 'Unbought', quantity: 1, price: 100.0, isPurchased: false, category: 'Electronic'),
    ];

    final stats = useCase.execute(items);

    expect(stats['Food'], 25.0); // (2 * 10) + (1 * 5)
    expect(stats['Toiletries'], 6.0); // (3 * 2)
    expect(stats['Electronic'], isNull); // Not purchased
  });

  test('should return empty map if no items are purchased', () {
    final items = [
      Item(id: '1', listId: 'l1', name: 'Milk', isPurchased: false, category: 'Food'),
    ];

    final stats = useCase.execute(items);

    expect(stats, isEmpty);
  });
}
