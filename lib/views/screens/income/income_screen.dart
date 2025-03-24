import 'package:expense_tracker/data/models/income_model/income_model.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/text_styles/app_texts.dart';
import 'package:expense_tracker/viewmodels/expense/expense_viewmodel.dart';
import 'package:expense_tracker/viewmodels/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Salary';
  String _selectedWallet = 'Bank Account';

  final List<String> _categories = [
    'Salary',
    'Investment',
    'Gift',
    'Bonus',
    'Other',
  ];
  final List<String> _wallets = ['Cash', 'Bank Account', 'PayTM', 'Google Pay'];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenseViewModel = Provider.of<ExpenseViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Income', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How much?',
                    style: TextStyle(color: Colors.white60, fontSize: 16),
                  ),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: '₹0',
                      hintStyle: TextStyle(
                        color: Colors.white38,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      prefixText: '₹',
                      prefixStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category dropdown
                      const Text('Category', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedCategory,
                            items: _categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Description field
                      const Text('Description', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Add description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Wallet dropdown
                      const Text('Wallet', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedWallet,
                            items: _wallets.map((wallet) {
                              return DropdownMenuItem<String>(
                                value: wallet,
                                child: Text(wallet),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedWallet = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final expenseViewModel =
                                Provider.of<ExpenseViewModel>(context,
                                    listen: false);
                            final homeViewModel = Provider.of<HomeViewModel>(
                                context,
                                listen: false);
                            final amount =
                                double.tryParse(_amountController.text) ?? 0.0;
                            final category = _selectedCategory;
                            final description = _descriptionController.text;
                            final wallet = _selectedWallet;

                            expenseViewModel
                                .addIncome(
                              amount: amount,
                              category: category,
                              description: description,
                              wallet: wallet,
                            )
                                .then((_) {
                              // Update recent transactions in HomeViewModel
                              final newIncome = Income(
                                id: expenseViewModel.incomes.last.id,
                                amount: amount,
                                category: category,
                                description: description,
                                wallet: wallet,
                                date: DateTime.now(),
                              );
                              homeViewModel.updateRecentTransactions(newIncome);

                              // Navigate back
                              Navigator.pop(context);
                            });
                          },

                          // async {
                          //   if (_formKey.currentState!.validate()) {
                          //     final amount =
                          //         double.tryParse(_amountController.text) ?? 0;
                          //     await expenseViewModel.addIncome(
                          //       amount: amount,
                          //       category: _selectedCategory,
                          //       description: _descriptionController.text,
                          //       wallet: _selectedWallet,
                          //     );
                          //     if (context.mounted) {
                          //       Navigator.pop(context);
                          //     }
                          //   }
                          // },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
