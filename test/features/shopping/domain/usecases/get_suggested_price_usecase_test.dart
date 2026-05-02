import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/entities/item.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/repositories/shopping_repository.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/usecases/get_suggested_price_usecase.dart';

class MockShoppingRepository extends Mock implements ShoppingRepository {}

void main() {
  late GetSuggestedPriceUseCase useCase;
  late MockShoppingRepository mockRepository;

  setUp(() {
    mockRepository = MockShoppingRepository();
    useCase = GetSuggestedPriceUseCase(mockRepository);
  });

  test('should return last price from history', () async {
    final history = [
      Item(id: '1', listId: 'l1', name: 'Milk', price: 10.0, category: 'Food'),
      Item(id: '2', listId: 'l2', name: 'Milk', price: 12.0, category: 'Food'),
    ];

    when(() => mockRepository.getAllItemsHistory('Milk'))
        .thenAnswer((_) async => history);

    final result = await useCase.execute('Milk');

    expect(result, 12.0);
    verify(() => mockRepository.getAllItemsHistory('Milk')).called(1);
  });

  test('should return null if no history found', () async {
    when(() => mockRepository.getAllItemsHistory('Milk'))
        .thenAnswer((_) async => []);

    final result = await useCase.execute('Milk');

    expect(result, isNull);
  });

  test('should return null for empty input', () async {
    final result = await useCase.execute('');
    expect(result, isNull);
    verifyNever(() => mockRepository.getAllItemsHistory(any()));
  });
}
