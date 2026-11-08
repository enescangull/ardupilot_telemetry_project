import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      constraints: BoxConstraints(minWidth: 112),
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        border: Border.all(color: Color(0xFF262C36), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF9BA7B4))),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFFE6EDF3),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                TextSpan(
                  text: " $unit",
                  style: TextStyle(fontSize: 13, color: Color(0xFF9BA7B4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
