import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/sheets_empty_state_cta.dart';

class SheetsPage extends StatelessWidget {
  const SheetsPage({required this.onAddSheet, super.key});

  static const _horizontalPadding = 32.0;
  static const _verticalPadding = 24.0;
  static const _contentSpacing = 24.0;
  static const _illustrationSize = 220.0;

  final VoidCallback onAddSheet;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              _horizontalPadding,
              _verticalPadding,
              _horizontalPadding,
              0,
            ),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: _verticalPadding),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: _contentSpacing,
                    children: [
                      SvgPicture.asset(
                        'assets/images/sheets_empty_state.svg',
                        key: const ValueKey('sheets-empty-state-illustration'),
                        width: _illustrationSize,
                        height: _illustrationSize,
                        fit: BoxFit.contain,
                        excludeFromSemantics: true,
                      ),
                      const _SheetsEmptyStateText(),
                      SheetsEmptyStateCta(onPressed: onAddSheet),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetsEmptyStateText extends StatelessWidget {
  const _SheetsEmptyStateText();

  static const _textSpacing = 8.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: _textSpacing,
      children: [
        Text(
          'No sheets yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            'Create your first sheet to start tracking expenses by trip, '
            'project, or category.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
              height: 20 / 14,
            ),
          ),
        ),
      ],
    );
  }
}
