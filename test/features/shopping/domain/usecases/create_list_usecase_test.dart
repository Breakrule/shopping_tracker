import 'package:flutter_test/flutter_test.dart';
import 'package:monthly_shop_tracker/features/shopping/domain/usecases/create_list_usecase.dart';
import 'mock_shopping_repository.dart';

void main() {
  late CreateListUseCase useCase;
  late MockShoppingRepository mockRepository;

  setUp(() {
    mockRepository = MockShoppingRepository();
    useCase = CreateListUseCase(mockRepository);
  });

  test('should add a new list to repository when name is valid', () async {
    const listName = 'Weekly Groceries';
    
    await useCase.execute(listName);

    expect(mockRepository.lists.length, 1);
    expect(mockRepository.lists.first.name, listName);
    expect(mockRepository.lists.first.id, isNotEmpty);
  });

  test('should throw exception when name is empty', () async {
    expect(() => useCase.execute('  '), throwsException);
    expect(mockRepository.lists.isEmpty, true);
  });
}
