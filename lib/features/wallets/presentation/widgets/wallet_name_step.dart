import 'package:flutter/material.dart';

import 'wallet_creation_flow_scaffold.dart';

class WalletNameStep extends StatelessWidget {
  const WalletNameStep({
    required this.controller,
    required this.onChanged,
    required this.onBack,
    required this.onContinue,
    this.errorText,
    this.backButtonKey,
    this.ctaButtonKey,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final String? errorText;
  final Key? backButtonKey;
  final Key? ctaButtonKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.outlineVariant),
    );

    return WalletCreationFlowScaffold(
      step: 1,
      onBack: onBack,
      ctaLabel: 'Continue',
      onCtaPressed: onContinue,
      backButtonKey: backButtonKey,
      ctaButtonKey: ctaButtonKey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Name your wallet',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Give your wallet a name that describes its funding source — like “Cash”, “Chase Visa”, or “Mom”.',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Wallet Name',
              style: TextStyle(
                color: Color(0xFF475569),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const ValueKey('wallet-name-field'),
              controller: controller,
              autofocus: true,
              onChanged: onChanged,
              onSubmitted: (_) => onContinue(),
              textInputAction: TextInputAction.done,
              autocorrect: false,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Primary Checking',
                hintStyle: TextStyle(
                  color: colors.outline,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                errorText: errorText,
                filled: true,
                fillColor: colors.surfaceContainerLowest,
                prefixIcon: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: colors.outline,
                  size: 18,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 48,
                ),
                contentPadding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: BorderSide(color: colors.primary, width: 1.5),
                ),
                errorBorder: border.copyWith(
                  borderSide: BorderSide(color: colors.error),
                ),
                focusedErrorBorder: border.copyWith(
                  borderSide: BorderSide(color: colors.error, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
