import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final String category;
  final String description;
  final double amount;
  final bool isExpense;
  final DateTime date;
  final Function()? onDelete;

  const TransactionCard({
    Key? key,
    required this.category,
    required this.description,
    required this.amount,
    required this.isExpense,
    required this.date,
    this.onDelete,
  }) : super(key: key);

  String _formatTime() {
    return DateFormat('hh:mm a').format(date);
  }

  // Get icon and background color based on category
  IconData _getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'shopping':
        return Icons.shopping_bag;
      case 'subscription':
        return Icons.subscriptions;
      case 'travel':
        return Icons.directions_car;
      case 'food':
        return Icons.fastfood;
      default:
        return Icons.account_balance_wallet;
    }
  }

  Color _getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'shopping':
        return Colors.orange;
      case 'subscription':
        return Colors.purple;
      case 'travel':
        return Colors.blue;
      case 'food':
        return Colors.red;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconData = _getCategoryIcon();
    final backgroundColor = _getCategoryColor();

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (onDelete != null) {
          onDelete!();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconData,
                color: backgroundColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Amount and Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isExpense ? "- " : "+ "}₹${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: isExpense ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatTime(),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
