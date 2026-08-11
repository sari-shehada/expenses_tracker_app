import 'package:flutter/material.dart';

import '../domain/currency.dart';
import '../domain/currency_catalog.dart';
import 'pages/currency_selection_page.dart';

/// Lets a caller select a Currency from a [CurrencyCatalog].
///
/// It loads the catalog, gives the user a way to retry a failed load, and
/// reports the selected Currency through [onSelected].
class CurrencyPickerField extends StatefulWidget {
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
  State<CurrencyPickerField> createState() => _CurrencyPickerFieldState();
}

class _CurrencyPickerFieldState extends State<CurrencyPickerField> {
  late Future<List<Currency>> _currencies;

  @override
  void initState() {
    super.initState();
    _currencies = widget.catalog.getAll();
  }

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
        const SizedBox(height: 8),
        FutureBuilder<List<Currency>>(
          future: _currencies,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _CurrencyFieldSurface(
                borderColor: Theme.of(context).colorScheme.error,
                child: Row(
                  children: [
                    const Expanded(child: Text('Could not load currencies.')),
                    TextButton(
                      onPressed: _loadCurrencies,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData) {
              return const _CurrencyFieldSurface(
                child: Row(
                  children: [
                    SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 16),
                    Expanded(child: Text('Loading currencies')),
                  ],
                ),
              );
            }

            return _CurrencyFieldSurface(
              onTap: () => _selectCurrency(context, snapshot.data!),
              semanticsLabel: widget.selectedCurrency == null
                  ? 'Select currency'
                  : 'Currency: ${widget.selectedCurrency!.code}, ${widget.selectedCurrency!.name}',
              child: _CurrencyFieldContent(
                selectedCurrency: widget.selectedCurrency,
              ),
            );
          },
        ),
      ],
    );
  }

  void _loadCurrencies() {
    final currencies = widget.catalog.getAll();
    setState(() {
      _currencies = currencies;
    });
  }

  Future<void> _selectCurrency(
    BuildContext context,
    List<Currency> currencies,
  ) async {
    final currency = await Navigator.push<Currency>(
      context,
      MaterialPageRoute(
        builder: (_) => CurrencySelectionPage(
          currencies: currencies,
          selectedCode: widget.selectedCurrency?.code,
        ),
      ),
    );

    if (currency != null && mounted) {
      widget.onSelected(currency);
    }
  }
}

class _CurrencyFieldSurface extends StatelessWidget {
  const _CurrencyFieldSurface({
    required this.child,
    this.onTap,
    this.borderColor,
    this.semanticsLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? borderColor;
  final String? semanticsLabel;

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
        side: BorderSide(color: borderColor ?? colorScheme.outlineVariant),
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

    if (onTap == null) {
      return field;
    }

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
                    const SizedBox(height: 2),
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
