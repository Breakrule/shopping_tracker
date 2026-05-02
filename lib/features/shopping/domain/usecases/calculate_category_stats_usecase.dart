import '../entities/item.dart';

class CalculateCategoryStatsUseCase {
  Map<String, double> execute(List<Item> items) {
    final stats = <String, double>{};
    
    for (final item in items) {
      if (item.isPurchased && item.price != null) {
        final current = stats[item.category] ?? 0.0;
        stats[item.category] = current + (item.price! * item.quantity);
      }
    }
    
    return stats;
  }
}
