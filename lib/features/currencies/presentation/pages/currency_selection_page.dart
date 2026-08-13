import 'package:flutter/material.dart';

import '../../domain/currency.dart';

class CurrencySelectionPage extends StatefulWidget {
  const CurrencySelectionPage({
    required this.currencies,
    this.selectedCode,
    super.key,
  });

  final List<Currency> currencies;
  final String? selectedCode;

  @override
  State<CurrencySelectionPage> createState() => _CurrencySelectionPageState();
}

class _CurrencySelectionPageState extends State<CurrencySelectionPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final currencies = widget.currencies.where(_matchesQuery).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Select currency')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search currencies',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: currencies.isEmpty
                ? const Center(child: Text('No currencies found'))
                : ListView.builder(
                    itemCount: currencies.length,
                    itemBuilder: (context, index) {
                      final currency = currencies[index];
                      return ListTile(
                        key: ValueKey(currency.code),
                        leading: Text(
                          currency.symbol,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        title: Text('${currency.code} · ${currency.name}'),
                        subtitle: Text(currency.nativeSymbol),
                        trailing: currency.code == widget.selectedCode
                            ? const Icon(Icons.check)
                            : null,
                        onTap: () => Navigator.pop(context, currency),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  bool _matchesQuery(Currency currency) {
    final query = _query.trim().toLowerCase();
    return query.isEmpty ||
        currency.code.toLowerCase().contains(query) ||
        currency.name.toLowerCase().contains(query);
  }
}
