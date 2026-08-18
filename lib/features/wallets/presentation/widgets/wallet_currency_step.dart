import 'package:flutter/material.dart';

import '../../../../app/widgets/app_spacing.dart';
import '../../../currencies/domain/currency.dart';
import '../../../currencies/presentation/widgets/currency_selector.dart';
import 'wallet_creation_flow_scaffold.dart';
import 'wallet_creation_step_scroll_view.dart';

class WalletCurrencyStep extends StatelessWidget {
  const WalletCurrencyStep({
    required this.currencies,
    required this.selectedCode,
    required this.onSelected,
    required this.onBack,
    required this.onContinue,
    this.searchController,
    this.searchFocusNode,
    this.backButtonKey,
    this.ctaButtonKey,
    super.key,
  });

  final List<Currency> currencies;
  final String? selectedCode;
  final ValueChanged<Currency> onSelected;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final Key? backButtonKey;
  final Key? ctaButtonKey;

  @override
  Widget build(BuildContext context) {
    return WalletCreationFlowScaffold(
      step: 2,
      onBack: onBack,
      ctaLabel: 'Continue',
      onCtaPressed: selectedCode == null ? null : onContinue,
      backButtonKey: backButtonKey,
      ctaButtonKey: ctaButtonKey,
      body: WalletCurrencyStepBody(
        currencies: currencies,
        selectedCode: selectedCode,
        searchController: searchController,
        searchFocusNode: searchFocusNode,
        onSelected: onSelected,
      ),
    );
  }
}

class WalletCurrencyStepBody extends StatelessWidget {
  const WalletCurrencyStepBody({
    required this.currencies,
    required this.selectedCode,
    required this.onSelected,
    this.searchController,
    this.searchFocusNode,
    super.key,
  });

  final List<Currency> currencies;
  final String? selectedCode;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final ValueChanged<Currency> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select currency',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const AddVerticalSpacing(8),
              Text(
                'Choose the currency for this wallet',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CurrencySelector(
            currencies: currencies,
            selectedCode: selectedCode,
            onSelected: onSelected,
            searchController: searchController,
            searchFocusNode: searchFocusNode,
            searchPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            listPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            optionsScrollViewBuilder: (context, slivers) {
              return WalletCreationStepScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: slivers,
              );
            },
          ),
        ),
      ],
    );
  }
}
