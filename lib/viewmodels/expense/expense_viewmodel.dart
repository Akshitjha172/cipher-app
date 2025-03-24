import 'package:expense_tracker/data/models/expense_model/expense_model.dart';
import 'package:expense_tracker/data/models/income_model/income_model.dart';
import 'package:expense_tracker/data/repositories/transaction_repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ExpenseViewModel extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();
  final Uuid _uuid = const Uuid();

  bool _isLoading = false;
  List<Expense> _expenses = [];
  List<Income> _incomes = [];
  double _totalExpenses = 0;
  double _totalIncomes = 0;
  double _balance = 0;

  bool get isLoading => _isLoading;
  List<Expense> get expenses => _expenses;
  List<Income> get incomes => _incomes;
  double get totalExpenses => _totalExpenses;
  double get totalIncomes => _totalIncomes;
  double get balance => _balance;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _expenses = await _repository.getExpenses();
    _incomes = await _repository.getIncomes();
    _totalExpenses = await _repository.getTotalExpenses();
    _totalIncomes = await _repository.getTotalIncomes();
    _balance = _totalIncomes - _totalExpenses;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense({
    required double amount,
    required String category,
    required String description,
    required String wallet,
  }) async {
    final expense = Expense(
      id: _uuid.v4(),
      amount: amount,
      category: category,
      description: description,
      wallet: wallet,
      date: DateTime.now(),
    );

    await _repository.insertExpense(expense);
    _expenses.add(expense);
    _totalExpenses += amount;
    _balance -= amount;
    notifyListeners();
    // await loadData();
  }

  Future<void> deleteExpense(String id) async {
    await _repository.deleteExpense(id);
    await loadData();
  }

  Future<void> addIncome({
    required double amount,
    required String category,
    required String description,
    required String wallet,
  }) async {
    final income = Income(
      id: _uuid.v4(),
      amount: amount,
      category: category,
      description: description,
      wallet: wallet,
      date: DateTime.now(),
    );

    await _repository.insertIncome(income);
    // Update local state immediately
    _incomes.add(income);
    _totalIncomes += amount;
    _balance += amount;

    notifyListeners();
    // await loadData();
  }

  Future<void> deleteIncome(String id) async {
    await _repository.deleteIncome(id);
    await loadData();
  }

  Future<Map<String, List<dynamic>>> getRecentTransactions({
    int limit = 5,
  }) async {
    return await _repository.getRecentTransactions(limit: limit);
  }
}
