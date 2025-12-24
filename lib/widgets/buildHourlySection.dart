import 'package:flutter/material.dart';

class HourlySection extends StatelessWidget {
  final String title;
  final List<Widget> weatherCards; // Aquí recibimos las pastillas de clima

  const HourlySection({
    super.key,
    required this.title,
    required this.weatherCards,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),

        // Scroll Horizontal
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: weatherCards, // Usamos la lista que recibimos
          ),
        ),
      ],
    );
  }
}
