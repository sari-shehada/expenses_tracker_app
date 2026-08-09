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
    return FutureBuilder<List<Currency>>(
      future: _currencies,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load currencies.'),
              TextButton(
                onPressed: _loadCurrencies,
                child: const Text('Try again'),
              ),
            ],
          );
        }

        if (!snapshot.hasData) {
          return const OutlinedButton(
            onPressed: null,
            child: Text('Loading currencies'),
          );
        }

        return OutlinedButton(
          onPressed: () => _selectCurrency(context, snapshot.data!),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.selectedCurrency == null
                  ? 'Select currency'
                  : '${widget.selectedCurrency!.code} · ${widget.selectedCurrency!.name}',
            ),
          ),
        );
      },
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
