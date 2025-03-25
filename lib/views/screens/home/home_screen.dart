import 'package:expense_tracker/data/models/expense_model/expense_model.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/images/app_images.dart';
import 'package:expense_tracker/res/text_styles/app_texts.dart';
import 'package:expense_tracker/viewmodels/home/home_viewmodel.dart';
import 'package:expense_tracker/views/screens/allTransactions/all_transactions.dart';
import 'package:expense_tracker/views/screens/bottomNavBar/bottomNavBar.dart';
import 'package:expense_tracker/views/screens/home/widgets/accountBalanceCard.dart';
import 'package:expense_tracker/views/screens/home/widgets/timeFilter.dart';
import 'package:expense_tracker/views/screens/home/widgets/transactionList.dart';
import 'package:expense_tracker/views/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../expense/expense_screen.dart';
import '../income/income_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: homeViewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar with profile pic and notification
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: const AssetImage(
                              AppImages.userIcon,
                            ),
                          ),
                        ),
                        Text('Expense Tracker',
                            style: AppTextStyles.subheading),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.primary,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Account balance card
                    accountBalanceCard(homeViewModel: homeViewModel),

                    const SizedBox(height: 24),

                    // Time period filter
                    TimeFilter(),

                    const SizedBox(height: 24),

                    // Recent transactions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Transaction',
                          style: AppTextStyles.subheading,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AllTransactionsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'See All',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Transaction list
                    TransactionList(homeViewModel: homeViewModel),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.arrow_downward,
                      color: AppColors.incomeColor,
                    ),
                    title: const Text('Add Income'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const IncomeScreen(),
                        ),
                      ).then(
                        (_) => Provider.of<HomeViewModel>(
                          context,
                          listen: false,
                        ).loadHomeData(),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.arrow_upward,
                      color: AppColors.expenseColor,
                    ),
                    title: const Text('Add Expense'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExpenseScreen(),
                        ),
                      ).then(
                        (_) => Provider.of<HomeViewModel>(
                          context,
                          listen: false,
                        ).loadHomeData(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
