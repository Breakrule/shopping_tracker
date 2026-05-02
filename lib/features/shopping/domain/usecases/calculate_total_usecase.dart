import '../entities/item.dart';

/// Responsibility: Pure logic for calculating total of purchased items.
/// Why: Keeps calculation logic outside the UI/State layer.

class CalculateTotalUseCase {
  double execute(List<Item> items) {
    return items
        .where((item) => item.isPurchased && item.price != null)
        .fold(0.0, (sum, item) => sum + (item.price! * item.quantity));
  }
}
