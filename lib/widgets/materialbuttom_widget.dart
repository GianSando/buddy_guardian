import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MaterialButtomWidget extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;
  final EdgeInsets margin;
  final double? height;
  final double? fontSize;

  const MaterialButtomWidget({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.height = 50,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: double.infinity,
      child: MaterialButton(
        height: height,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.text,
              fontSize: fontSize,
              fontFamily: "IB",
            ),
          ),
        ),
      ),
    );
  }
}
