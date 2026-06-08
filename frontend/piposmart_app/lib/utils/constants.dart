import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ========== PRIMARY COLOR (MERAH #C20000) ==========
  static const Color primary = Color(0xFFC20000); // Merah utama
  static const Color primaryLight = Color(0xFFE53E3E); // Merah lebih terang
  static const Color primaryDark = Color(0xFF991B1B); // Merah lebih gelap
  static const Color primaryMid = Color(0xFFDC2626); // Variasi tengah
  static const Color primarySurface = Color(
    0xFFFEF2F2,
  ); // Background merah sangat muda

  // ========== NEUTRAL COLORS ==========
  static const Color background = Color(0xFFF8FAFC); // Background utama
  static const Color surface = Color(0xFFFFFFFF); // Card/surface putih
  static const Color textPrimary = Color(0xFF1E293B); // Teks utama
  static const Color textSecondary = Color(0xFF64748B); // Teks sekunder
  static const Color textHint = Color(0xFF94A3B8); // Teks hint/placeholder
  static const Color textOnPrimary = Color(
    0xFFFFFFFF,
  ); // Teks di atas primary (putih)
  static const Color textOnPrimaryMuted = Color(
    0xFFFEE2E2,
  ); // Teks muted di primary
  static const Color divider = Color(0xFFE2E8F0); // Garis pembatas
  static const Color border = Color(0xFFE2E8F0); // Border

  // ========== STATUS COLORS (Tetap konsisten) ==========
  static const Color success = Color(0xFF10B981); // Hijau sukses/lunas
  static const Color error = Color(0xFFEF4444); // Merah error
  static const Color info = Color(0xFF3B82F6); // Biru info/diterima
  static const Color warning = Color(0xFFF59E0B); // Amber warning/proses

  // ========== BADGE & CARD VARIATIONS (Disesuaikan dengan merah) ==========
  static const Color badgeOwner = Color(0xFFF59E0B); // Badge pemilik (amber)

  // Status transaksi
  static const Color statusDiterima = Color(0xFF3B82F6); // Biru
  static const Color statusDiproses = Color(0xFF06B6D4); // Cyan
  static const Color statusSiapDiambil = Color(0xFFF59E0B); // Orange
  static const Color statusSelesai = Color(0xFF10B981); // Hijau

  // Payment status
  static const Color paymentLunas = Color(0xFF10B981); // Hijau
  static const Color paymentLunasLight = Color(0xFFD1FAE5); // Hijau muda
  static const Color paymentBelum = Color(0xFFF59E0B); // Orange
  static const Color paymentBelumLight = Color(0xFFFEF3C7); // Orange muda

  // ========== CARD BACKGROUNDS (Harmoni dengan merah) ==========
  static const Color cardRedBg = Color(0xFFFEF2F2); // Merah sangat muda (NEW)
  static const Color cardRedIcon = Color(0xFFC20000); // Merah utama

  static const Color cardGreenBg = Color(0xFFD1FAE5); // Hijau sangat muda
  static const Color cardGreenIcon = Color(0xFF10B981); // Hijau

  static const Color cardYellowBg = Color(0xFFFEF3C7); // Kuning sangat muda
  static const Color cardYellowIcon = Color(0xFFF59E0B); // Orange

  static const Color cardBlueBg = Color(0xFFDBEAFE); // Biru sangat muda
  static const Color cardBlueIcon = Color(0xFF3B82F6); // Biru

  static const Color cardPinkBg = Color(0xFFFCE7F3); // Pink sangat muda
  static const Color cardPinkIcon = Color(0xFFEC4899); // Pink

  // ========== CARD STATUS (Disesuaikan dengan merah) ==========
  static const Color cardSelesai = Color(0xFF059669); // Hijau gelap
  static const Color cardSelesaiDark = Color(0xFF047857); // Hijau lebih gelap
  static const Color cardTerlambat = Color(
    0xFFDC2626,
  ); // Merah (sama dengan error)
  static const Color cardTerlambatDark = Color(
    0xFF991B1B,
  ); // Merah gelap (sama dengan primaryDark)
  static const Color cardHarusSelesai = Color(0xFFD97706); // Kuning tua
  static const Color cardHarusSelesaiDark = Color(
    0xFFB45309,
  ); // Kuning lebih tua

  // ========== BOTTOM NAVIGATION ==========
  static const Color bottomNavActive = primary; // Merah #C20000
  static const Color bottomNavInactive = Color(0xFF94A3B8); // Abu-abu

  // ========== ADDITIONAL UI ELEMENTS ==========
  static const Color floatingActionButton = primary; // Merah
  static const Color tabIndicator = primary; // Merah
  static const Color switchActive = primary; // Merah
  static const Color checkboxActive = primary; // Merah
  static const Color progressIndicator = primary;

  static Color? get badgeOrange => null; // Merah
}

class AppTextStyles {
  AppTextStyles._();

  // ========== HEADER STYLES ==========
  static const TextStyle headerTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
  );

  static const TextStyle headerSubtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textOnPrimaryMuted,
  );

  // ========== HEADLINE STYLES ==========
  static const TextStyle headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ========== BODY STYLES ==========
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  // ========== CAPTION & LABEL ==========
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle transCode = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryLight, // Merah terang
  );

  static const TextStyle amountRed = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary, // Merah utama untuk amount
  );

  static const TextStyle labelBold = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle menuLabel = TextStyle(
    fontSize: 11,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ========== BUTTON TEXT ==========
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true, // Bisa pakai Material 3 untuk better red tone
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      tertiary: AppColors.primaryDark,
      error: AppColors.error,
      surface: AppColors.surface,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textOnPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.textOnPrimary),
      titleTextStyle: AppTextStyles.headerTitle,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.surface,
      margin: const EdgeInsets.all(0),
    ),
    dividerColor: AppColors.divider,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      bodyLarge: AppTextStyles.body1,
      bodyMedium: AppTextStyles.body2,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.buttonText,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: AppTextStyles.buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.bottomNavActive,
      unselectedItemColor: AppColors.bottomNavInactive,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    tabBarTheme: const TabBarThemeData(
      indicatorColor: AppColors.tabIndicator,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.progressIndicator,
      circularTrackColor: AppColors.primarySurface,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.switchActive;
        }
        return AppColors.textHint;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight.withValues(alpha: 0.5);
        }
        return AppColors.border;
      }),
    ),
  );
}

// ========== EXTENSION UNTUK MEMUDAHKAN PENGGUNAAN ==========
extension AppColorScheme on BuildContext {
  AppColors get colors => AppColors._();
  AppTextStyles get textStyles => AppTextStyles._();

  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
