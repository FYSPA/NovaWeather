import 'package:flutter/material.dart';

class WeatherInfo extends StatelessWidget {
  final String temp;
  final String condition;

  const WeatherInfo({super.key, required this.temp, required this.condition});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            temp,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text(condition, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
