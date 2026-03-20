import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary
  static const Color primaryDarkNavy = Color(0xFF0F1C3F);
  static const Color secondaryNavy = Color(0xFF1A2340);
  static const Color accentOrange = Color(0xFFF97316);

  // Status
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningOrange = Color(0xFFF97316);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Backgrounds
  static const Color background = Color(0xFFF5F6FA);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF0F1C3F);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLabel = Color(0xFF9CA3AF);
  static const Color textBody = Color(0xFF374151);

  // Borders
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);

  // Colombia flag
  static const Color colombiaYellow = Color(0xFFFFD700);
  static const Color colombiaBlue = Color(0xFF003087);
  static const Color colombiaRed = Color(0xFFC8102E);

  // Extra
  static const Color surfaceGray = Color(0xFFF3F4F6);
  static const Color navyMid = Color(0xFF162040);
  static const Color navyLight = Color(0xFF1E3A5F);
  static const Color amberLight = Color(0xFFFFF7ED);
  static const Color greenLight = Color(0xFFF0FDF4);
  static const Color blueLight = Color(0xFFEFF6FF);
  static const Color yellowAmber = Color(0xFFF59E0B);
}

class AppTextStyles {
  static TextStyle h1(BuildContext context) => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle h2(BuildContext context) => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle h3(BuildContext context) => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle bodyRegular = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textBody,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle labelUppercase = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textLabel,
    letterSpacing: 0.08 * 11,
  );

  static TextStyle badgeText = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static TextStyle buttonCTA = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle bigNumber = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle monoPartida = GoogleFonts.sourceCodePro(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle priceTotal = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle sectionTitle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle cardTitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}

class AppDecorations {
  static BoxDecoration card = BoxDecoration(
    color: AppColors.cardWhite,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration elevatedCard = BoxDecoration(
    color: AppColors.cardWhite,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryDarkNavy.withValues(alpha: 0.12),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration darkCard = BoxDecoration(
    color: AppColors.primaryDarkNavy,
    borderRadius: BorderRadius.circular(16),
  );

  static InputDecoration inputDecoration(String label, String hint,
      {Widget? suffix, Widget? prefix}) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: AppTextStyles.bodySmall,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textBody,
        ),
        filled: true,
        fillColor: AppColors.cardWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryDarkNavy, width: 2),
        ),
        suffixIcon: suffix,
        prefixIcon: prefix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryDarkNavy,
          primary: AppColors.primaryDarkNavy,
          secondary: AppColors.accentOrange,
          surface: AppColors.cardWhite,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryDarkNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDarkNavy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: AppTextStyles.buttonCTA,
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDarkNavy,
            side: const BorderSide(color: AppColors.primaryDarkNavy, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: AppTextStyles.buttonCTA.copyWith(color: AppColors.primaryDarkNavy),
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceGray,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          labelStyle: AppTextStyles.bodySmall,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      );
}
