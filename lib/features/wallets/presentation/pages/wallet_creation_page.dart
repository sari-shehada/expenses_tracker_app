import 'package:flutter/material.dart';

import '../../../currencies/domain/currency.dart';
import '../../../currencies/domain/currency_catalog.dart';
import '../../../currencies/presentation/currency_picker_field.dart';
import '../../domain/wallet_repository.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Currency? _currency;
  bool _isSaving = false;
  bool _currencyIsMissing = false;
  bool _saveFailed = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add wallet',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            children: [
              const _WalletCreationHero(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Wallet name',
                  filled: true,
                  fillColor: Color.alphaBlend(
                    colorScheme.primaryContainer.withAlpha(48),
                    colorScheme.surface,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 22,
                  ),
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder.copyWith(
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: inputBorder.copyWith(
                    borderSide: BorderSide(color: colorScheme.error),
                  ),
                  focusedErrorBorder: inputBorder.copyWith(
                    borderSide: BorderSide(
                      color: colorScheme.error,
                      width: 1.5,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.titleMedium,
                textInputAction: TextInputAction.done,
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              CurrencyPickerField(
                catalog: widget.currencyCatalog,
                selectedCurrency: _currency,
                onSelected: _selectCurrency,
              ),
              if (_currencyIsMissing) ...[
                const SizedBox(height: 8),
                Text(
                  'Select a currency.',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSaving ? null : _createWallet,
                child: Text(_isSaving ? 'Creating Wallet' : 'Create Wallet'),
              ),
              if (_saveFailed) ...[
                const SizedBox(height: 16),
                const Text('Could not save Wallet.'),
                TextButton(
                  onPressed: _isSaving ? null : _createWallet,
                  child: const Text('Try again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a Wallet name.';
    }
    return null;
  }

  void _selectCurrency(Currency currency) {
    setState(() {
      _currency = currency;
      _currencyIsMissing = false;
    });
  }

  Future<void> _createWallet() async {
    final nameIsValid = _formKey.currentState!.validate();
    final currencyIsSelected = _currency != null;

    setState(() {
      _currencyIsMissing = !currencyIsSelected;
      _saveFailed = false;
    });

    if (!nameIsValid || !currencyIsSelected) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.repository.createWallet(
        userId: widget.userId,
        name: _nameController.text,
        currencyCode: _currency!.code,
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

class _WalletCreationHero extends StatelessWidget {
  const _WalletCreationHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: const AspectRatio(
            aspectRatio: 1.35,
            child: Image(
              key: ValueKey('wallet-creation-hero'),
              image: AssetImage('assets/images/wallet_creation_hero.png'),
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Keep track of where your\nmoney comes from.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
