import 'package:flutter/material.dart';

class BetterErrorText extends StatelessWidget {
  const BetterErrorText({
    super.key,
    required this.errorText,
    this.fontSize = 16.0,
    this.backgroundColor = const Color(0xFFFFE5E5),
    this.textColor = const Color(0xFFB00020),
  });

  final String errorText;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: textColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: textColor, size: fontSize + 4),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              errorText,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}