import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/text_styles/app_texts.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined
              ? Colors.transparent
              : (backgroundColor ?? AppColors.primary),
          foregroundColor: isOutlined
              ? (textColor ?? AppColors.primary)
              : (textColor ?? Colors.white),
          side: isOutlined
              ? BorderSide(color: backgroundColor ?? AppColors.primary)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isOutlined ? 0 : 2,
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
                style: AppTextStyles.button.copyWith(
                  color: isOutlined
                      ? (textColor ?? AppColors.primary)
                      : (textColor ?? Colors.white),
                ),
              ),
      ),
    );
  }
}
