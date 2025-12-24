import 'package:flutter/material.dart';

class HourWeatherPill extends StatelessWidget {
  final String temperature;
  final String imagePath;
  final int hour;
  final bool isActive;

  const HourWeatherPill({
    super.key,
    required this.temperature,
    required this.imagePath,
    required this.hour,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: isActive
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hora
          Text(
            "$hour:00",
            style: TextStyle(
              color: isActive ? Colors.black : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(height: 40, width: 40, child: Image.asset(imagePath)),
          const SizedBox(height: 8),
          Text(
            temperature,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
