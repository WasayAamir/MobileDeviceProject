import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String label;
  final double currentExp;
  final double requiredExp;

  ProgressBar({required this.label, required this.currentExp, required this.requiredExp});

  @override
  Widget build(BuildContext context) {
    // Ensure that the width factor is clamped between 0 and 1
    final double progress = requiredExp > 0 ? (currentExp / requiredExp).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Container(
          height: 10.0,
          decoration: BoxDecoration(
            color: Colors.grey[300], // Background color for the bar
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: FractionallySizedBox(
            widthFactor: progress,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue, // Progress color
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
