import 'package:flutter/material.dart';

import '../../../../app/widgets/app_page_header.dart';
import '../../../../app/widgets/app_primary_cta_button.dart';
import 'wallet_creation_step_indicator.dart';

class WalletCreationFlowScaffold extends StatelessWidget {
  const WalletCreationFlowScaffold({
    required this.step,
    required this.body,
    required this.onBack,
    required this.ctaLabel,
    required this.onCtaPressed,
    this.isCtaLoading = false,
    this.ctaLoadingLabel = 'Loading',
    this.ctaMessage,
    this.backButtonKey,
    this.ctaButtonKey,
    super.key,
  });

  final int step;
  final Widget body;
  final VoidCallback onBack;
  final String ctaLabel;
  final VoidCallback? onCtaPressed;
  final bool isCtaLoading;
  final String ctaLoadingLabel;
  final Widget? ctaMessage;
  final Key? backButtonKey;
  final Key? ctaButtonKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: 'Create Wallet',
              onBack: onBack,
              backButtonKey: backButtonKey,
            ),
            WalletCreationStepIndicator(step: step),
            Expanded(child: body),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (ctaMessage != null) ...[
                        ctaMessage!,
                        const SizedBox(height: 8),
                      ],
                      AppPrimaryCtaButton(
                        label: ctaLabel,
                        loadingLabel: ctaLoadingLabel,
                        isLoading: isCtaLoading,
                        onPressed: onCtaPressed,
                        buttonKey: ctaButtonKey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
