import 'package:flutter/material.dart';

import '../../../currencies/domain/currency.dart';
import '../../../currencies/domain/currency_catalog.dart';
import '../../domain/wallet_appearance.dart';
import '../../domain/wallet_repository.dart';
import '../widgets/wallet_appearance_step.dart';
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
    _nameFocusNode.dispose();
    _currencySearchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      canPop: _step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _showStep(_step - 1);
        }
      },
      child: switch (_step) {
        1 => WalletNameStep(
          controller: _nameController,
          focusNode: _nameFocusNode,
          errorText: _nameError,
          onChanged: _handleNameChanged,
          onBack: () => Navigator.maybePop(context),
          onContinue: _continueFromName,
          backButtonKey: const ValueKey('wallet-creation-back-button'),
          ctaButtonKey: const ValueKey('wallet-name-continue-button'),
        ),
        2 => WalletCurrencyStep(
          currencies: widget.currencyCatalog.currencies,
          selectedCode: _currency?.code,
          searchFocusNode: _currencySearchFocusNode,
          onSelected: (currency) => setState(() => _currency = currency),
          onBack: () => _showStep(1),
          onContinue: () => _showStep(3),
          backButtonKey: const ValueKey('wallet-creation-back-button'),
          ctaButtonKey: const ValueKey('wallet-currency-continue-button'),
        ),
        3 => WalletAppearanceStep(
          selectedColorKey: _colorKey,
          selectedIconKey: _iconKey,
          onColorSelected: (key) => setState(() => _colorKey = key),
          onIconSelected: (key) => setState(() => _iconKey = key),
          onBack: () => _showStep(2),
          onCreate: _createWallet,
          isCreating: _isSaving,
          saveFailed: _saveFailed,
          onRetry: _createWallet,
          backButtonKey: const ValueKey('wallet-creation-back-button'),
          ctaButtonKey: const ValueKey('create-wallet-button'),
        ),
        _ => throw StateError('Unsupported Wallet creation step: $_step'),
      },
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
