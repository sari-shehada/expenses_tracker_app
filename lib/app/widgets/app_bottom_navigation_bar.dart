import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_shell_layout.dart';
import 'app_spacing.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  }) : assert(
         selectedIndex >= 0 && selectedIndex < _destinations.length,
         'selectedIndex must match an available destination.',
       );

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const double height = AppShellLayout.navigationHeight;
  static const double maxWidth = 354;

  static const _destinations = [
    _AppNavigationDestination(
      label: 'Sheets',
      assetName: 'assets/icons/app_navigation/sheets.svg',
    ),
    _AppNavigationDestination(
      label: 'Wallets',
      assetName: 'assets/icons/app_navigation/wallets.svg',
    ),
    _AppNavigationDestination(
      label: 'Settings',
      assetName: 'assets/icons/app_navigation/settings.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D0F172A),
              offset: Offset(0, 8),
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest.withValues(
                  alpha: 0.8,
                ),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: SizedBox(
                height: height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var index = 0; index < _destinations.length; index++)
                        _AppNavigationTab(
                          destination: _destinations[index],
                          selected: selectedIndex == index,
                          onTap: () => onDestinationSelected(index),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppNavigationTab extends StatelessWidget {
  const _AppNavigationTab({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _AppNavigationDestination destination;
  final bool selected;
  final VoidCallback onTap;

  static const _inactiveColor = Color(0xFF475569);

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : _inactiveColor;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            width: 64,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  destination.assetName,
                  key: ValueKey('${destination.label}-navigation-icon'),
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                const AddVerticalSpacing(4),
                Text(
                  destination.label,
                  maxLines: 1,
                  softWrap: false,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppNavigationDestination {
  const _AppNavigationDestination({
    required this.label,
    required this.assetName,
  });

  final String label;
  final String assetName;
}
