import 'package:flutter_test/flutter_test.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/entities/item.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/usecases/calculate_total_usecase.dart';

void main() {
  late CalculateTotalUseCase useCase;

  setUp(() {
    useCase = CalculateTotalUseCase();
  });

  test('should calculate total only for purchased items with price', () {
    final items = [
      Item(id: '1', listId: 'l1', name: 'Item 1', quantity: 2, price: 10.0, isPurchased: true), // 20.0
      Item(id: '2', listId: 'l1', name: 'Item 2', quantity: 1, price: 5.0, isPurchased: false), // ignored (not purchased)
      Item(id: '3', listId: 'l1', name: 'Item 3', quantity: 3, price: null, isPurchased: true), // ignored (no price)
      Item(id: '4', listId: 'l1', name: 'Item 4', quantity: 1, price: 15.0, isPurchased: true), // 15.0
    ];

    final total = useCase.execute(items);

    expect(total, 35.0);
  });

  test('should return 0.0 when no items are purchased', () {
    final items = [
      Item(id: '1', listId: 'l1', name: 'Item 1', quantity: 2, price: 10.0, isPurchased: false),
    ];

    final total = useCase.execute(items);

    expect(total, 0.0);
  });

  test('should return 0.0 for empty list', () {
    final total = useCase.execute([]);
    expect(total, 0.0);
  });
}
