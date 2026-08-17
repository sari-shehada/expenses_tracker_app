import 'package:flutter/material.dart';

import '../../../../app/widgets/app_page_header.dart';
import '../../../../app/widgets/app_primary_cta_button.dart';
import 'wallet_creation_step_indicator.dart';
import 'wallet_creation_step_scroll_view.dart';

class WalletCreationFlowScaffold extends StatelessWidget {
  static const _keyboardInsetAnimationDuration = Duration(milliseconds: 250);
  static const _ctaHeight = 48.0;
  static const _ctaBottomPadding = 16.0;
  static const _contentToCtaSpacing = 24.0;
  static const _ctaMessageHeight = 48.0;
  static const _ctaMessageSpacing = 8.0;

  const WalletCreationFlowScaffold({
    required this.step,
    required this.body,
    required this.onBack,
    required this.ctaLabel,
    required this.onCtaPressed,
    this.isCtaLoading = false,
    this.ctaLoadingLabel = 'Loading',
    this.ctaMessage,
    this.accentColor,
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
  final Color? accentColor;
  final Key? backButtonKey;
  final Key? ctaButtonKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: 'Create Wallet',
              onBack: onBack,
              backButtonKey: backButtonKey,
            ),
            WalletCreationStepIndicator(step: step, accentColor: accentColor),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  WalletCreationFlowMetrics(
                    ctaClearance: _ctaClearance(context),
                    child: body,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedPadding(
                      key: const ValueKey('wallet-creation-keyboard-inset'),
                      duration: _keyboardInsetAnimationDuration,
                      curve: Curves.easeOutCubic,
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                        child: Center(
                          heightFactor: 1,
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
                                  backgroundColor: accentColor,
                                  buttonKey: ctaButtonKey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _ctaClearance(BuildContext context) {
    return MediaQuery.viewInsetsOf(context).bottom +
        _ctaBottomPadding +
        _ctaHeight +
        _contentToCtaSpacing +
        (ctaMessage == null ? 0 : _ctaMessageHeight + _ctaMessageSpacing);
  }
}
