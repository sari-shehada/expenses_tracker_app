import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const lightColorScheme = ColorScheme.light(
    primary: Color(0xFF263B92),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE2E6FF),
    onPrimaryContainer: Color(0xFF101A36),
    secondary: Color(0xFF626FB8),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE3E5FF),
    onSecondaryContainer: Color(0xFF101A36),
    surface: Color(0xFFFCF9F4),
    onSurface: Color(0xFF101A36),
    onSurfaceVariant: Color(0xFF5D5D69),
    outline: Color(0xFF797986),
    outlineVariant: Color(0xFFCAC8D1),
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
  );

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFCF9F4),
      foregroundColor: Color(0xFF101A36),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
