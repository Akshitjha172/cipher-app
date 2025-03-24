import 'package:expense_tracker/res/text_styles/app_texts.dart';
import 'package:expense_tracker/views/widgets/transaction_card.dart';
import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({required this.name, required this.icon, required this.color});
}

class CategorySelector extends StatefulWidget {
  final Function(Category) onCategorySelected;
  final bool isExpense;

  const CategorySelector({
    Key? key,
    required this.onCategorySelected,
    this.isExpense = true,
  }) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  Category? _selectedCategory;

  // Predefined categories
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _initializeCategories();
  }

  void _initializeCategories() {
    if (widget.isExpense) {
      _categories = [
        Category(name: 'Food', icon: Icons.restaurant, color: Colors.orange),
        Category(
          name: 'Shopping',
          icon: Icons.shopping_bag,
          color: Colors.purple,
        ),
        Category(
          name: 'Travel',
          icon: Icons.directions_car,
          color: Colors.blue,
        ),
        Category(
          name: 'Subscription',
          icon: Icons.subscriptions,
          color: Colors.indigo,
        ),
      ];
    } else {
      _categories = [
        Category(name: 'Salary', icon: Icons.wallet, color: Colors.green),
        Category(name: 'Freelance', icon: Icons.work, color: Colors.teal),
        Category(
          name: 'Investments',
          icon: Icons.trending_up,
          color: Colors.blue,
        ),
        Category(name: 'Gifts', icon: Icons.card_giftcard, color: Colors.pink),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            _showCategoryBottomSheet(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory?.name ?? 'Category',
                  style: TextStyle(
                    color:
                        _selectedCategory != null ? Colors.black : Colors.grey,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (_selectedCategory != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 8,
              children: [
                Chip(
                  backgroundColor: _selectedCategory!.color.withOpacity(0.1),
                  avatar: Icon(
                    _selectedCategory!.icon,
                    color: _selectedCategory!.color,
                    size: 18,
                  ),
                  label: Text(
                    _selectedCategory!.name,
                    style: TextStyle(
                      color: _selectedCategory!.color,
                    ),
                  ),
                  onDeleted: () {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                  deleteIconColor: _selectedCategory!.color,
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Category', style: AppTextStyles.caption),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory?.name == category.name;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                        widget.onCategorySelected(category);
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: category.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(
                                      color: category.color,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Icon(
                              category.icon,
                              color: category.color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.name,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
