import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Headers
  static TextStyle h1 = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h2 = GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h3 = GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body
  static TextStyle bodyLarge = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Labels
  static TextStyle labelLarge = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMedium = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle labelSmall = GoogleFonts.cairo(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
  );

  // Button
  static TextStyle button = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  // Title Card
  static TextStyle titleCard = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Subtitle
  static TextStyle subtitle = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // White Text Styles
  static TextStyle h1White = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle h2White = GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle bodyWhite = GoogleFonts.cairo(
    fontSize: 14,
    color: AppColors.textWhite,
  );
}
