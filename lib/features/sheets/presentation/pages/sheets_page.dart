import 'package:flutter/material.dart';

class SheetsPage extends StatelessWidget {
  const SheetsPage({required this.onAddSheet, super.key});

  final VoidCallback onAddSheet;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final headingColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.74),
      colorScheme.surface,
    );

    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final minimumContentHeight = (constraints.maxHeight - 96).clamp(
              0.0,
              double.infinity,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 88),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minimumContentHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: const AspectRatio(
                            aspectRatio: 1,
                            child: Image(
                              key: ValueKey('sheets-empty-state-illustration'),
                              image: AssetImage(
                                'assets/images/sheets_empty_state.png',
                              ),
                              fit: BoxFit.contain,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No Sheets yet',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: headingColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create a Sheet to organize expenses for a month, '
                          'trip, or project.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            key: const ValueKey('add-sheet-button'),
            onPressed: onAddSheet,
            label: const Text('Add Sheet'),
          ),
        ),
      ],
    );
  }
}
