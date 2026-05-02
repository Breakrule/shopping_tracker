import 'package:flutter_test/flutter_test.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/usecases/add_item_usecase.dart';
import 'mock_shopping_repository.dart';

void main() {
  late AddItemUseCase useCase;
  late MockShoppingRepository mockRepository;

  setUp(() {
    mockRepository = MockShoppingRepository();
    useCase = AddItemUseCase(mockRepository);
  });

  test('should add a new item to repository when data is valid', () async {
    const listId = 'list-123';
    const itemName = 'Milk';
    
    await useCase.execute(listId: listId, name: itemName, quantity: 2, price: 3.5);

    expect(mockRepository.items.length, 1);
    final item = mockRepository.items.first;
    expect(item.name, itemName);
    expect(item.listId, listId);
    expect(item.quantity, 2);
    expect(item.price, 3.5);
    expect(item.isPurchased, false);
  });

  test('should throw exception when name is empty', () async {
    expect(() => useCase.execute(listId: '1', name: ''), throwsException);
  });

  test('should throw exception when quantity is less than 1', () async {
    expect(() => useCase.execute(listId: '1', name: 'A', quantity: 0), throwsException);
  });
}
