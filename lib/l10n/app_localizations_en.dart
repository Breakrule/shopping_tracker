// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Monthly Shop Tracker';

  @override
  String get homeTitle => 'My Shopping Lists';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get noListsYet => 'Your shopping journey starts here';

  @override
  String get noListsSub =>
      'Create your first list to organize your monthly shopping with precision.';

  @override
  String get addList => 'Create New List';

  @override
  String get listName => 'List Name (e.g., May 2024)';

  @override
  String get budget => 'Monthly Budget (Optional)';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get deleteList => 'Delete List?';

  @override
  String get deleteListConfirm =>
      'This will delete all items in this list. This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get items => 'items';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get overBudget => 'OVER BUDGET';

  @override
  String get insights => 'Spending Insights';

  @override
  String get aisleView => 'Aisle View';

  @override
  String get listView => 'List View';

  @override
  String get noItemsYet => 'This list is empty';

  @override
  String get noItemsSub =>
      'Add items you need to buy and we\'ll help you track your spending.';

  @override
  String get newItem => 'New Item';

  @override
  String get itemName => 'Item Name';

  @override
  String get category => 'Category';

  @override
  String get quantity => 'Quantity';

  @override
  String get price => 'Price';

  @override
  String suggestion(String price) {
    return 'Suggestion: Rp $price';
  }

  @override
  String get addToList => 'Add to List';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get categories => 'Categories';

  @override
  String get addCustomCategory => 'Add Custom Category';

  @override
  String get development => 'Development';

  @override
  String get seedData => 'Seed Dummy Data';

  @override
  String get dummyDataSuccess => 'Dummy data seeded successfully!';

  @override
  String get systemDefault => 'System Default';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get newCategory => 'New Category';

  @override
  String get categoryName => 'Category name';

  @override
  String get add => 'Add';

  @override
  String get required => 'Required';

  @override
  String get minQuantity => 'Min 1';
}
