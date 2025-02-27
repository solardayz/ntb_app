import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatCircle extends StatelessWidget {
  final String label;
  final double percent;
  final Color progressColor;

  const StatCircle({
    super.key,
    required this.label,
    required this.percent,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 40.0,
          lineWidth: 5.0,
          percent: percent,
          center: Text(
            "${(percent * 100).toInt()}%",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          progressColor: progressColor,
          backgroundColor: Colors.grey[800]!,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1000,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
