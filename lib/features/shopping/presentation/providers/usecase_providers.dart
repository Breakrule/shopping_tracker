import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/calculate_category_stats_usecase.dart';
import '../../domain/usecases/calculate_total_usecase.dart';
import '../../domain/usecases/create_list_usecase.dart';
import '../../domain/usecases/add_item_usecase.dart';
import '../../domain/usecases/export_list_usecase.dart';
import '../../domain/usecases/get_suggested_price_usecase.dart';
import '../../domain/usecases/toggle_item_purchased_usecase.dart';
import '../../domain/usecases/seed_data_usecase.dart';
import 'providers.dart';

final createListUseCaseProvider = Provider((ref) {
  return CreateListUseCase(ref.read(shoppingRepositoryProvider));
});

final addItemUseCaseProvider = Provider((ref) {
  return AddItemUseCase(ref.read(shoppingRepositoryProvider));
});

final calculateTotalUseCaseProvider = Provider((ref) {
  return CalculateTotalUseCase();
});

final calculateCategoryStatsUseCaseProvider = Provider((ref) {
  return CalculateCategoryStatsUseCase();
});

final exportListUseCaseProvider = Provider((ref) {
  return ExportListUseCase();
});

final toggleItemPurchasedUseCaseProvider = Provider((ref) {
  return ToggleItemPurchasedUseCase(ref.read(shoppingRepositoryProvider));
});

final getSuggestedPriceUseCaseProvider = Provider((ref) {
  return GetSuggestedPriceUseCase(ref.read(shoppingRepositoryProvider));
});

final seedDataUseCaseProvider = Provider((ref) {
  return SeedDataUseCase(ref.read(shoppingRepositoryProvider));
});
