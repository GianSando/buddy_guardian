import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonDecorationWidget2 extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color? buttonColor;
  final double? minWidth;
  const ButtonDecorationWidget2({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor =
        (buttonColor == AppColors.blueColors) ? Colors.white : AppColors.text;
    if (buttonColor == AppColors.orangeAcents) {
      textColor = AppColors.text;
    }
    return Center(
      child: Container(
        height: 45,
        decoration:
            BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 2, color: AppColors.text)),
        child: MaterialButton(
          elevation: 5,
          minWidth: minWidth ?? 150,
          color: buttonColor ?? AppColors.purpleColors,
          splashColor: AppColors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              text,
              style:
                  TextStyle(fontFamily: "CB", fontSize: 16, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
