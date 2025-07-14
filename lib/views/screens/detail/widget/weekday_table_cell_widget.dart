import 'package:flutter/material.dart';

class WeekdayTableCellWidget extends StatelessWidget {
  final String sessionLabel;
  final Color color;

  const WeekdayTableCellWidget({
    Key? key,
    required this.sessionLabel,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: color,
      alignment: Alignment.center,
      child: Text(
        sessionLabel,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
