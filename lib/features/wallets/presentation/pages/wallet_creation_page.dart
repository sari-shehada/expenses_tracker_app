import 'package:flutter/material.dart';

import '../../../currencies/domain/currency.dart';
import '../../../currencies/domain/currency_catalog.dart';
import '../../domain/wallet_appearance.dart';
import '../../domain/wallet_repository.dart';
import '../wallet_color_palette.dart';
import '../widgets/wallet_appearance_step.dart';
import '../widgets/wallet_creation_flow_scaffold.dart';
import '../widgets/wallet_creation_step_transition.dart';
import '../widgets/wallet_currency_step.dart';
import '../widgets/wallet_name_step.dart';

class WalletCreationPage extends StatefulWidget {
  const WalletCreationPage({
    required this.userId,
    required this.repository,
    required this.currencyCatalog,
    super.key,
  });

  final String userId;
  final WalletRepository repository;
  final CurrencyCatalog currencyCatalog;

  @override
  State<WalletCreationPage> createState() => _WalletCreationPageState();
}

class _WalletCreationPageState extends State<WalletCreationPage> {
  final _nameController = TextEditingController();
  final _currencySearchController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _currencySearchFocusNode = FocusNode();
  int _step = 1;
  Currency? _currency;
  String _colorKey = WalletAppearance.defaultColorKey;
  String _iconKey = WalletAppearance.defaultIconKey;
  String? _nameError;
  bool _isSaving = false;
  bool _saveFailed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _currencySearchController.dispose();
    _nameFocusNode.dispose();
    _currencySearchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedPalette = WalletColorPalette.resolve(_colorKey);

    return PopScope<bool>(
      canPop: _step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _showStep(_step - 1);
        }
      },
      child: WalletCreationFlowScaffold(
        step: _step,
        accentColor: _step == 3 ? selectedPalette.accentColor : null,
        onBack: _step == 1
            ? () => Navigator.maybePop(context)
            : () => _showStep(_step - 1),
        ctaLabel: _step == 3 ? 'Create Wallet' : 'Continue',
        ctaLoadingLabel: 'Creating wallet',
        isCtaLoading: _step == 3 && _isSaving,
        onCtaPressed: switch (_step) {
          1 => _continueFromName,
          2 => _currency == null ? null : () => _showStep(3),
          3 => _createWallet,
          _ => throw StateError('Unsupported Wallet creation step: $_step'),
        },
        ctaMessage: _step == 3 && _saveFailed
            ? WalletSaveFailureMessage(
                isCreating: _isSaving,
                onRetry: _createWallet,
              )
            : null,
        backButtonKey: const ValueKey('wallet-creation-back-button'),
        ctaButtonKey: switch (_step) {
          1 => const ValueKey('wallet-name-continue-button'),
          2 => const ValueKey('wallet-currency-continue-button'),
          3 => const ValueKey('create-wallet-button'),
          _ => throw StateError('Unsupported Wallet creation step: $_step'),
        },
        body: WalletCreationStepTransition(
          key: const ValueKey('wallet-creation-step-transition'),
          step: _step,
          animate: !MediaQuery.disableAnimationsOf(context),
          child: switch (_step) {
            1 => WalletNameStepBody(
              key: const ValueKey('wallet-creation-step-1'),
              controller: _nameController,
              focusNode: _nameFocusNode,
              errorText: _nameError,
              onChanged: _handleNameChanged,
              onContinue: _continueFromName,
            ),
            2 => WalletCurrencyStepBody(
              key: const ValueKey('wallet-creation-step-2'),
              currencies: widget.currencyCatalog.currencies,
              selectedCode: _currency?.code,
              searchController: _currencySearchController,
              searchFocusNode: _currencySearchFocusNode,
              onSelected: (currency) => setState(() => _currency = currency),
            ),
            3 => WalletAppearanceStepBody(
              key: const ValueKey('wallet-creation-step-3'),
              selectedColorKey: _colorKey,
              selectedIconKey: _iconKey,
              onColorSelected: (key) => setState(() => _colorKey = key),
              onIconSelected: (key) => setState(() => _iconKey = key),
            ),
            _ => throw StateError('Unsupported Wallet creation step: $_step'),
          },
        ),
      ),
    );
  }

  void _handleNameChanged(String value) {
    if (_nameError != null && value.trim().isNotEmpty) {
      setState(() => _nameError = null);
    }
  }

  void _continueFromName() {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Enter a Wallet name.');
      return;
    }

    if (_nameFocusNode.hasFocus) {
      _currencySearchFocusNode.requestFocus();
    }
    setState(() {
      _nameError = null;
      _step = 2;
    });
  }

  void _showStep(int step) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _step = step);
  }

  Future<void> _createWallet() async {
    if (_isSaving) {
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = 'Enter a Wallet name.';
        _step = 1;
      });
      return;
    }

    if (_currency == null) {
      setState(() => _step = 2);
      return;
    }

    setState(() {
      _isSaving = true;
      _saveFailed = false;
    });

    try {
      await widget.repository.createWallet(
        userId: widget.userId,
        name: _nameController.text,
        currencyCode: _currency!.code,
        colorKey: _colorKey,
        iconKey: _iconKey,
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saveFailed = true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
