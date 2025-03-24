import 'package:expense_tracker/data/models/expense_model/expense_model.dart';
import 'package:expense_tracker/data/models/income_model/income_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class TransactionRepository {
  static final TransactionRepository _instance =
      TransactionRepository._internal();

  factory TransactionRepository() {
    return _instance;
  }

  TransactionRepository._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'cipher_x.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses(
        id TEXT PRIMARY KEY,
        amount REAL,
        category TEXT,
        description TEXT,
        wallet TEXT,
        date INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE incomes(
        id TEXT PRIMARY KEY,
        amount REAL,
        category TEXT,
        description TEXT,
        wallet TEXT,
        date INTEGER
      )
    ''');
  }

  // Expense methods
  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<void> deleteExpense(String id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Income methods
  Future<void> insertIncome(Income income) async {
    final db = await database;
    await db.insert(
      'incomes',
      income.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Income>> getIncomes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'incomes',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return Income.fromMap(maps[i]);
    });
  }

  Future<void> deleteIncome(String id) async {
    final db = await database;
    await db.delete('incomes', where: 'id = ?', whereArgs: [id]);
  }

  // Summary methods
  Future<double> getTotalExpenses() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses',
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> getTotalIncomes() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM incomes',
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<Map<String, List<dynamic>>> getRecentTransactions({
    int limit = 5,
  }) async {
    final db = await database;
    final expenseMaps = await db.query(
      'expenses',
      orderBy: 'date DESC',
      limit: limit,
    );

    final incomeMaps = await db.query(
      'incomes',
      orderBy: 'date DESC',
      limit: limit,
    );

    final expenses = expenseMaps.map((e) => Expense.fromMap(e)).toList();
    final incomes = incomeMaps.map((e) => Income.fromMap(e)).toList();

    return {'expenses': expenses, 'incomes': incomes};
  }
}
