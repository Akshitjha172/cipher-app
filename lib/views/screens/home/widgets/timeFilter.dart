import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/text_styles/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimeFilter extends StatelessWidget {
  const TimeFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                'Today',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Week',
                style: AppTextStyles.caption,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Month',
                style: AppTextStyles.caption,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Year',
                style: AppTextStyles.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
