import 'package:flutter/material.dart';

import '../../../../app/widgets/app_spacing.dart';
import '../../domain/currency.dart';
import '../currency_flag.dart';

typedef CurrencyOptionsScrollViewBuilder =
    Widget Function(BuildContext context, List<Widget> slivers);

class CurrencySelector extends StatefulWidget {
  const CurrencySelector({
    required this.currencies,
    required this.onSelected,
    this.selectedCode,
    this.searchController,
    this.searchFocusNode,
    this.searchPadding = const EdgeInsets.fromLTRB(20, 4, 20, 12),
    this.listPadding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
    this.optionsScrollViewBuilder,
    super.key,
  });

  final List<Currency> currencies;
  final String? selectedCode;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final ValueChanged<Currency> onSelected;
  final EdgeInsetsGeometry searchPadding;
  final EdgeInsetsGeometry listPadding;
  final CurrencyOptionsScrollViewBuilder? optionsScrollViewBuilder;

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  late String _query;

  @override
  void initState() {
    super.initState();
    _query = widget.searchController?.text ?? '';
  }

  @override
  void didUpdateWidget(CurrencySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchController != widget.searchController) {
      _query = widget.searchController?.text ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencies = widget.currencies.where(_matchesQuery).toList();

    return Column(
      children: [
        _CurrencySearchField(
          controller: widget.searchController,
          focusNode: widget.searchFocusNode,
          padding: widget.searchPadding,
          onChanged: (value) => setState(() => _query = value),
        ),
        Expanded(
          child: currencies.isEmpty
              ? const _EmptySearchResults()
              : _buildOptions(context, currencies),
        ),
      ],
    );
  }

  Widget _buildOptions(BuildContext context, List<Currency> currencies) {
    Widget buildOption(BuildContext context, int index) {
      final currency = currencies[index];
      return _CurrencyOption(
        currency: currency,
        isSelected: currency.code == widget.selectedCode,
        onSelected: () => widget.onSelected(currency),
      );
    }

    final scrollViewBuilder = widget.optionsScrollViewBuilder;
    final slivers = [
      SliverPadding(
        padding: widget.listPadding,
        sliver: SliverList.separated(
          itemCount: currencies.length,
          itemBuilder: buildOption,
          separatorBuilder: (_, _) => const AddVerticalSpacing(8),
        ),
      ),
    ];

    if (scrollViewBuilder != null) {
      return scrollViewBuilder(context, slivers);
    }

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: slivers,
    );
  }

  bool _matchesQuery(Currency currency) {
    final query = _query.trim().toLowerCase();
    return query.isEmpty ||
        currency.code.toLowerCase().contains(query) ||
        currency.name.toLowerCase().contains(query);
  }
}

class _CurrencySearchField extends StatelessWidget {
  const _CurrencySearchField({
    required this.controller,
    required this.focusNode,
    required this.padding,
    required this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry padding;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: padding,
      child: SizedBox(
        height: 50,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: colors.onSurface.withValues(alpha: 0.02),
                      offset: const Offset(0, 4),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
            TextField(
              key: const ValueKey('currency-search-field'),
              controller: controller,
              focusNode: focusNode,
              autocorrect: false,
              textInputAction: TextInputAction.search,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 15,
                height: 20 / 15,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Search currency',
                hintStyle: TextStyle(
                  color: colors.outline,
                  fontSize: 15,
                  height: 20 / 15,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 10),
                  child: Icon(
                    Icons.search_rounded,
                    color: colors.outline,
                    size: 18,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 50,
                ),
                contentPadding: const EdgeInsets.fromLTRB(0, 15, 16, 15),
              ),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyOption extends StatelessWidget {
  const _CurrencyOption({
    required this.currency,
    required this.isSelected,
    required this.onSelected,
  });

  final Currency currency;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(16);

    return Semantics(
      key: ValueKey(currency.code),
      button: true,
      selected: isSelected,
      label: '${currency.code}, ${currency.name}, ${currency.symbol}',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primaryContainer
              : colors.surfaceContainerLowest,
          borderRadius: borderRadius,
          border: Border.all(
            color: isSelected
                ? colors.secondaryContainer
                : colors.outlineVariant,
          ),
          boxShadow: isSelected
              ? const []
              : [
                  BoxShadow(
                    color: colors.onSurface.withValues(alpha: 0.01),
                    offset: const Offset(0, 2),
                    blurRadius: 2,
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSelected,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: ClipOval(
                        child: CurrencyFlag(
                          currencyCode: currency.code,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currency.code,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 16,
                              height: 20 / 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const AddVerticalSpacing(2),
                          Text(
                            currency.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 13,
                              height: 18 / 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      currency.symbol,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        color: isSelected ? colors.primary : colors.outline,
                        fontSize: 16,
                        height: 20 / 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 12),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const SizedBox.square(
                          dimension: 22,
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptySearchResults extends StatelessWidget {
  const _EmptySearchResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No currencies found',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
