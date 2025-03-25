// bottom_navbar.dart
import 'package:flutter/material.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import '../profile/profile_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: currentIndex == 0 ? AppColors.primary : Colors.grey,
              ),
              onPressed: () => onTap(0),
            ),
            // IconButton(
            //   icon: Icon(
            //     Icons.bar_chart,
            //     color: currentIndex == 1 ? AppColors.primary : Colors.grey,
            //   ),
            //   onPressed: () => onTap(1),
            // ),
            const SizedBox(width: 40), // For FAB space
            // IconButton(
            //   icon: Icon(
            //     Icons.notifications,
            //     color: currentIndex == 2 ? AppColors.primary : Colors.grey,
            //   ),
            //   onPressed: () => onTap(2),
            // ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: currentIndex == 3 ? AppColors.primary : Colors.grey,
              ),
              onPressed: () {
                onTap(3);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
