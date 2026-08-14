import 'package:flutter/material.dart';

import '../../../../app/widgets/app_page_header.dart';
import '../../domain/currency.dart';
import '../widgets/currency_selector.dart';

class CurrencySelectionPage extends StatelessWidget {
  const CurrencySelectionPage({
    required this.currencies,
    this.selectedCode,
    super.key,
  });

  final List<Currency> currencies;
  final String? selectedCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: 'Select Currency',
              backButtonKey: const ValueKey('currency-selection-back-button'),
              onBack: () => Navigator.maybePop(context),
            ),
            Expanded(
              child: CurrencySelector(
                currencies: currencies,
                selectedCode: selectedCode,
                onSelected: (currency) => Navigator.pop(context, currency),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
