import 'package:expense_tracker/data/models/expense_model/expense_model.dart';
import 'package:expense_tracker/data/models/income_model/income_model.dart';
import 'package:expense_tracker/data/repositories/transaction_repository/transaction_repository.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  bool _isLoading = false;
  double _totalExpenses = 0;
  double _totalIncomes = 0;
  double _balance = 0;
  List<dynamic> _recentTransactions = [];

  bool get isLoading => _isLoading;
  double get totalExpenses => _totalExpenses;
  double get totalIncomes => _totalIncomes;
  double get balance => _balance;
  List<dynamic> get recentTransactions => _recentTransactions;

  Future<void> loadHomeData() async {
    _isLoading = true;
    notifyListeners();

    _totalExpenses = await _repository.getTotalExpenses();
    _totalIncomes = await _repository.getTotalIncomes();
    _balance = _totalIncomes - _totalExpenses;

    final transactionsData = await _repository.getRecentTransactions();
    final expenses = transactionsData['expenses'] as List<Expense>;
    final incomes = transactionsData['incomes'] as List<Income>;

    // Combine and sort by date
    _recentTransactions = [...expenses, ...incomes];
    _recentTransactions.sort((a, b) => b.date.compareTo(a.date));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTransaction(dynamic transaction) async {
    if (transaction is Expense) {
      await _repository.deleteExpense(transaction.id);
    } else if (transaction is Income) {
      await _repository.deleteIncome(transaction.id);
    }

    // Reload home data to update balance and transaction list
    await loadHomeData();
  }

  void updateRecentTransactions(dynamic newTransaction) {
    // Add the new transaction to the list
    _recentTransactions.add(newTransaction);

    // Sort the list by date
    _recentTransactions.sort((a, b) => b.date.compareTo(a.date));

    // Limit to 5 recent transactions
    if (_recentTransactions.length > 5) {
      _recentTransactions = _recentTransactions.sublist(0, 5);
    }

    // Update balance
    if (newTransaction is Expense) {
      _totalExpenses += newTransaction.amount;
      _balance -= newTransaction.amount;
    } else if (newTransaction is Income) {
      _totalIncomes += newTransaction.amount;
      _balance += newTransaction.amount;
    }

    notifyListeners();
  }
}
