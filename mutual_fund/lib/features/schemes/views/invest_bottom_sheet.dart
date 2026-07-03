import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InvestBottomSheet extends StatefulWidget {
  const InvestBottomSheet({super.key});

  @override
  State<InvestBottomSheet> createState() => _InvestBottomSheetState();
}

class _InvestBottomSheetState extends State<InvestBottomSheet> {
  final _amountController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final text = _amountController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorText = 'Please enter an amount';
      });
      return;
    }

    final amount = double.tryParse(text);
    if (amount == null) {
      setState(() {
        _errorText = 'Invalid amount';
      });
      return;
    }

    if (amount < 100) {
      setState(() {
        _errorText = 'Minimum amount is Rs. 100';
      });
      return;
    }

    // Success
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully invested Rs. ${amount.toStringAsFixed(0)}!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Invest in Scheme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Investment Amount (₹)',
              hintText: 'e.g., 5000',
              prefixIcon: const Icon(Icons.currency_rupee),
              errorText: _errorText,
            ),
            onChanged: (value) {
              if (_errorText != null) {
                setState(() {
                  _errorText = null;
                });
              }
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _onConfirm,
              child: const Text('Confirm Investment'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
