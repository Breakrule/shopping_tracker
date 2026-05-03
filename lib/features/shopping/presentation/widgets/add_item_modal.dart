import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:monthly_shop_tracker/l10n/app_localizations.dart';
import 'package:monthly_shop_tracker/core/theme/app_colors.dart';
import 'package:monthly_shop_tracker/features/settings/presentation/providers/settings_provider.dart';
import '../providers/items_notifier.dart';
import '../providers/usecase_providers.dart';

/// Responsibility: Bottom sheet form to add a new item to a shopping list.

void showAddItemModal(BuildContext context, String listId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddItemForm(listId: listId),
      ),
    ),
  );
}

class AddItemForm extends ConsumerStatefulWidget {
  final String listId;
  const AddItemForm({super.key, required this.listId});

  @override
  ConsumerState<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends ConsumerState<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _priceController = TextEditingController();

  late String _selectedCategory;
  double? _suggestedPrice;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider).valueOrNull;
    _selectedCategory = settings?.categories.first ?? 'Other';
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onNameChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (_nameController.text.trim().isEmpty) {
        setState(() => _suggestedPrice = null);
        return;
      }
      final price = await ref.read(getSuggestedPriceUseCaseProvider).execute(_nameController.text);
      if (mounted) {
        setState(() => _suggestedPrice = price);
      }
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(itemsProvider(widget.listId).notifier).addItem(
            name: _nameController.text,
            quantity: int.parse(_quantityController.text),
            price: double.tryParse(_priceController.text),
            category: _selectedCategory,
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    final categories = settings?.categories ?? ['Other'];
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.newItem,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                RawAutocomplete<String>(
                  textEditingController: _nameController,
                  focusNode: FocusNode(),
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return await ref
                        .read(getItemSuggestionsUseCaseProvider)
                        .execute(textEditingValue.text);
                  },
                  onSelected: (String selection) async {
                    final defaults = await ref
                        .read(getItemDefaultsUseCaseProvider)
                        .execute(selection);
                    if (mounted) {
                      setState(() {
                        if (defaults.category != null) {
                          _selectedCategory = defaults.category!;
                        }
                        _suggestedPrice = defaults.suggestedPrice;
                      });
                    }
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.itemName,
                        prefixIcon: const Icon(Icons.shopping_bag_outlined),
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      validator: (val) =>
                          val == null || val.isEmpty ? AppLocalizations.of(context)!.required : null,
                      onFieldSubmitted: (value) => onFieldSubmitted(),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 48,
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return ListTile(
                                title: Text(option),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.category,
                    prefixIcon: const Icon(Icons.category_outlined),
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: categories.map((cat) {
                    final color = AppColors.getCategoryColor(cat);
                    return DropdownMenuItem(
                      value: cat,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(cat),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedCategory = val);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.quantity,
                          prefixIcon: const Icon(Icons.inventory_2_outlined),
                          filled: true,
                          fillColor: theme.cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) return AppLocalizations.of(context)!.required;
                          final q = int.tryParse(val);
                          if (q == null || q < 1) return AppLocalizations.of(context)!.minQuantity;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.price,
                              prefixIcon: const Icon(Icons.payments_outlined),
                              filled: true,
                              fillColor: theme.cardColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                          ),
                          if (_suggestedPrice != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 4),
                              child: InkWell(
                                onTap: () {
                                  _priceController.text =
                                      _suggestedPrice!.toStringAsFixed(0);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.suggestion(NumberFormat('#,###').format(_suggestedPrice)),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.addToList,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ].animate(interval: 50.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
            ),
          ),
    );
  }
}
