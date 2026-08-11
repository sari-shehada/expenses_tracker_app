import 'package:expenses_tracker/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defines the selected app-wide light palette', () {
    final theme = AppTheme.light;

    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme, AppTheme.lightColorScheme);
    expect(theme.colorScheme.primary, const Color(0xFF263B92));
    expect(theme.colorScheme.secondaryContainer, const Color(0xFFE3E5FF));
    expect(theme.colorScheme.surface, const Color(0xFFFCF9F4));
    expect(theme.colorScheme.onSurface, const Color(0xFF101A36));
    expect(theme.scaffoldBackgroundColor, theme.colorScheme.surface);
  });
}
