import 'package:expense_tracker/data/models/expense_model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/viewmodels/home/home_viewmodel.dart';
import 'package:expense_tracker/views/widgets/transaction_card.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Transactions"),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: homeViewModel.recentTransactions.isEmpty
            ? const Center(child: Text("No transactions found"))
            : ListView.separated(
                itemCount: homeViewModel.recentTransactions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final transaction = homeViewModel.recentTransactions[index];
                  final bool isExpense = transaction is Expense;

                  return Dismissible(
                    key: Key(transaction.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      Provider.of<HomeViewModel>(context, listen: false)
                          .deleteTransaction(transaction);
                    },
                    child: TransactionCard(
                      category: transaction.category,
                      description: transaction.description,
                      amount: transaction.amount,
                      isExpense: isExpense,
                      date: transaction.date,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
