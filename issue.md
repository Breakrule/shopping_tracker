# Monthly Shop Tracker - Feature Expansion Plan (Phase 2)

You are building upon a production-ready Flutter MVP using strict incremental steps.

Rules:
1. Do NOT skip steps.
2. Do NOT add features not explicitly requested.
3. Every step must follow Input → Process → Output format.
4. Output must be COMPLETE and copy-paste ready.
5. Use null-safety and latest stable Flutter practices.
6. Add comments explaining non-trivial logic.
7. Keep architecture clean (feature-first + layered).
8. Use Riverpod (state) and Hive (local DB).
9. Fail fast: if unclear requirement → state assumption explicitly.

---

## Phase 1: Monthly Budgeting & Dynamic Theming

### Step 1: Domain & Data Expansion (Settings & Budget)
**Goal:** Add budget to Shopping List and create global Settings for theme.
- **Input:** `shopping_list.dart`, `shopping_list_model.dart`
- **Process:** 
  - Add `double? targetBudget` to `ShoppingList` and `ShoppingListModel` (HiveField 3).
  - Create `settings.dart` entity (ThemeMode enum) and `settings_model.dart` for Hive.
- **Output:** Updated models and new settings files.

### Step 2: Repositories & Code Generation
**Goal:** Implement data access for new fields and run builder.
- **Input:** Hive Boxes, Repositories
- **Process:**
  - Create `SettingsRepository` (Data + Domain).
  - Update `ShoppingRepositoryImpl` if needed.
  - Run `dart run build_runner build --delete-conflicting-outputs`.
- **Output:** Generated `.g.dart` files, functional repositories.

### Step 3: Dynamic Theming State & UI
**Goal:** Apply theme globally based on settings.
- **Input:** `main.dart`, `SettingsRepository`
- **Process:**
  - Create `ThemeNotifier` (Riverpod) reading from `SettingsRepository`.
  - Update `main.dart` `MaterialApp` to watch `themeProvider`.
  - Add a Theme Toggle button in `HomeScreen` AppBar.
- **Output:** App responds to theme toggle and persists choice.

### Step 4: Budgeting UI Integration
**Goal:** Allow users to set and view budget limits.
- **Input:** `home_screen.dart`, `list_detail_screen.dart`
- **Process:**
  - Update List Creation dialog to include optional "Target Budget" input.
  - Update `ListDetailScreen` header to show `Total / Budget`.
  - Make total text turn **red** if total > targetBudget.
- **Output:** Functional budgeting UI.

---

## Phase 2: Category Statistics & Export

### Step 5: Category Statistics Use Case
**Goal:** Calculate category spending breakdown.
- **Input:** `Item` entities.
- **Process:**
  - Create `CalculateCategoryStatsUseCase`.
  - Input: `List<Item>`. Output: `Map<String, double>` (Category -> Total Amount).
- **Output:** Pure Dart use case file with unit test.

### Step 6: Statistics UI Integration
**Goal:** Display insights in the Detail Screen.
- **Input:** `list_detail_screen.dart`
- **Process:**
  - Add a "Stats" button or a collapsible BottomSheet in `ListDetailScreen`.
  - Display a list/progress bar for each category showing the percentage and amount spent.
- **Output:** Visual spending breakdown by category.

### Step 7: Export to Text/Share
**Goal:** Allow sharing the shopping list.
- **Input:** `pubspec.yaml`, `ListDetailScreen`
- **Process:**
  - Add `share_plus` dependency.
  - Create `ExportListUseCase` to format the list into a clean text string (e.g., "[x] 2x Milk - Rp 30,000").
  - Add an Export/Share icon button to `ListDetailScreen` AppBar.
- **Output:** Users can share the list via native OS dialog.

---

## Phase 3: Price History & Smart Suggestions

### Step 8: Price History Use Cases
**Goal:** Extract historical item data across all lists.
- **Input:** `ShoppingRepository`
- **Process:**
  - Add `Future<List<Item>> getAllItemsHistory(String itemName)` to repo.
  - Create `GetSuggestedPriceUseCase`: Returns the most recent price for a given item name.
- **Output:** Repository updates and new Use Case.

### Step 9: Smart Suggestions in Add Item Modal
**Goal:** Auto-fill or suggest prices when typing item names.
- **Input:** `add_item_modal.dart`
- **Process:**
  - Listen to `_nameController` changes.
  - Debounce input and query `GetSuggestedPriceUseCase`.
  - If a past price is found, display a "Suggest: Rp X" chip that auto-fills the price field when tapped.
- **Output:** Intelligent Add Item form.

### Step 10: Price History View
**Goal:** Let users see how prices changed.
- **Input:** `list_detail_screen.dart`
- **Process:**
  - Add a long-press or info icon action to items in the list.
  - Open a simple dialog showing the item's past prices and dates from `getAllItemsHistory`.
- **Output:** Price history dialog.

---

## Phase 4: Finalization
### Step 11: Unit Testing New Use Cases
**Goal:** Ensure statistics and history logic is sound.
- **Input:** `test/` folder.
- **Process:** Write tests for `CalculateCategoryStatsUseCase` and `GetSuggestedPriceUseCase`.
- **Output:** Passing test suite.

### Step 12: End-to-End Validation & Polish
**Goal:** Validate all Phase 2 features.
- **Input:** Entire App.
- **Process:** Manual E2E test, fix UI clipping, ensure Hive boxes aren't leaking.
- **Output:** Production-ready Phase 2 release.
