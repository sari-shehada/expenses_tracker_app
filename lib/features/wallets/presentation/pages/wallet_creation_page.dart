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
    return Scaffold(
      appBar: AppBar(title: const Text('New Wallet')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
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
