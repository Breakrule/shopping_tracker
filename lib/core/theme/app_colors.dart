import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  
  // Category colors (HSL-tailored for harmony)
  static const Map<String, Color> categoryColors = {
    'Groceries': Color(0xFF10B981), // Emerald
    'Household': Color(0xFF3B82F6), // Blue
    'Health': Color(0xFFEF4444),    // Red
    'Personal': Color(0xFFF59E0B),  // Amber
    'Other': Color(0xFF6B7280),     // Gray
  };

  static Color getCategoryColor(String? category) {
    return categoryColors[category] ?? categoryColors['Other']!;
  }
}
