import 'package:expense_tracker/data/models/expense_model/expense_model.dart';
import 'package:expense_tracker/viewmodels/home/home_viewmodel.dart';
import 'package:expense_tracker/views/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.homeViewModel,
  });

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeViewModel.recentTransactions.length > 5
          ? 5
          : homeViewModel.recentTransactions.length,
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
            // Handle delete action
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
    );
  }
}
