class Income {
  final String id;
  final double amount;
  final String category;
  final String description;
  final String wallet;
  final DateTime date;

  Income({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.wallet,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'description': description,
      'wallet': wallet,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      description: map['description'],
      wallet: map['wallet'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }
}
