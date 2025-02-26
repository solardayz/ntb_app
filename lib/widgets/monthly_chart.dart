import 'package:flutter/material.dart';

class MonthlyChart extends StatelessWidget {
  final List<String> monthLabels;
  final List<double> animationHeights;

  const MonthlyChart({
    super.key,
    required this.monthLabels,
    required this.animationHeights,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(monthLabels.length, (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    height: animationHeights[index],
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    monthLabels[index],
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
