import 'package:intl/intl.dart';
import '../entities/item.dart';

class ExportListUseCase {
  String execute(String listName, List<Item> items, double total) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final buffer = StringBuffer();
    buffer.writeln('🛒 Shopping List: $listName');
    buffer.writeln('Total Purchased: ${formatter.format(total)}');
    buffer.writeln('---');

    for (final item in items) {
      final status = item.isPurchased ? '[x]' : '[ ]';
      final price = item.price != null ? ' - ${formatter.format(item.price! * item.quantity)}' : '';
      buffer.writeln('$status ${item.quantity}x ${item.name}$price');
    }

    return buffer.toString();
  }
}
