import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const lightColorScheme = ColorScheme.light(
    primary: Color(0xFF2563EB),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFEFF6FF),
    onPrimaryContainer: Color(0xFF0F172A),
    secondary: Color(0xFF64748B),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFBFDBFE),
    onSecondaryContainer: Color(0xFF0F172A),
    surface: Color(0xFFF8FAFC),
    surfaceContainerLowest: Colors.white,
    onSurface: Color(0xFF0F172A),
    onSurfaceVariant: Color(0xFF64748B),
    outline: Color(0xFF94A3B8),
    outlineVariant: Color(0xFFE2E8F0),
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
  );

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
