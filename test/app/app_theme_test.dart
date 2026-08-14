import 'package:expenses_tracker/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defines the selected app-wide light palette', () {
    final theme = AppTheme.light;

    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme, AppTheme.lightColorScheme);
    expect(theme.colorScheme.primary, const Color(0xFF2563EB));
    expect(theme.colorScheme.primaryContainer, const Color(0xFFEFF6FF));
    expect(theme.colorScheme.secondary, const Color(0xFF64748B));
    expect(theme.colorScheme.secondaryContainer, const Color(0xFFBFDBFE));
    expect(theme.colorScheme.surface, const Color(0xFFF8FAFC));
    expect(theme.colorScheme.surfaceContainerLowest, Colors.white);
    expect(theme.colorScheme.onSurface, const Color(0xFF0F172A));
    expect(theme.colorScheme.onSurfaceVariant, const Color(0xFF64748B));
    expect(theme.colorScheme.outline, const Color(0xFF94A3B8));
    expect(theme.colorScheme.outlineVariant, const Color(0xFFE2E8F0));
    expect(theme.scaffoldBackgroundColor, theme.colorScheme.surface);
    expect(theme.appBarTheme.backgroundColor, theme.colorScheme.surface);
    expect(theme.appBarTheme.foregroundColor, theme.colorScheme.onSurface);
  });
}
