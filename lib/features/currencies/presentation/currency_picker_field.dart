import 'package:flutter/material.dart';

import '../../../app/widgets/app_spacing.dart';
import '../domain/currency.dart';
import '../domain/currency_catalog.dart';
import 'pages/currency_selection_page.dart';

/// Lets a caller select a Currency from an initialized [CurrencyCatalog].
class CurrencyPickerField extends StatelessWidget {
  const CurrencyPickerField({
    required this.catalog,
    required this.onSelected,
    this.selectedCurrency,
    super.key,
  });

  final CurrencyCatalog catalog;
  final ValueChanged<Currency> onSelected;
  final Currency? selectedCurrency;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency',
          style: textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const AddVerticalSpacing(8),
        _CurrencyFieldSurface(
          onTap: () => _selectCurrency(context),
          semanticsLabel: selectedCurrency == null
              ? 'Select currency'
              : 'Currency: ${selectedCurrency!.code}, ${selectedCurrency!.name}',
          child: _CurrencyFieldContent(selectedCurrency: selectedCurrency),
        ),
      ],
    );
  }

  Future<void> _selectCurrency(BuildContext context) async {
    final currency = await Navigator.push<Currency>(
      context,
      MaterialPageRoute(
        builder: (_) => CurrencySelectionPage(
          currencies: catalog.currencies,
          selectedCode: selectedCurrency?.code,
        ),
      ),
    );

    if (currency != null && context.mounted) {
      onSelected(currency);
    }
  }
}

class _CurrencyFieldSurface extends StatelessWidget {
  const _CurrencyFieldSurface({
    required this.child,
    required this.onTap,
    required this.semanticsLabel,
  });

  final Widget child;
  final VoidCallback onTap;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(24);

    final field = Material(
      key: const ValueKey('currency-picker-surface'),
      color: Color.alphaBlend(
        colorScheme.primaryContainer.withAlpha(48),
        colorScheme.surface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 96),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: child,
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      container: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: field,
    );
  }
}

class _CurrencyFieldContent extends StatelessWidget {
  const _CurrencyFieldContent({required this.selectedCurrency});

  final Currency? selectedCurrency;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: selectedCurrency == null
              ? Icon(
                  Icons.currency_exchange_rounded,
                  color: colorScheme.onPrimaryContainer,
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      selectedCurrency!.symbol,
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: selectedCurrency == null
              ? Text('Select currency', style: textTheme.titleMedium)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedCurrency!.code,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const AddVerticalSpacing(2),
                    Text(
                      selectedCurrency!.name,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.chevron_right_rounded),
      ],
    );
  }
}
