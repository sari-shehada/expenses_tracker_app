import 'package:flutter/material.dart';

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    required this.title,
    required this.onBack,
    this.backButtonKey,
    super.key,
  });

  final String title;
  final VoidCallback onBack;
  final Key? backButtonKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 48,
              child: IconButton(
                key: backButtonKey,
                tooltip: 'Back',
                padding: const EdgeInsets.all(4),
                onPressed: onBack,
                icon: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLowest,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: SizedBox.square(
                    dimension: 40,
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: colors.onSurface,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 22,
                  height: 28 / 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
