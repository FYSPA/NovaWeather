import 'package:flutter/material.dart';

class WeekRow extends StatelessWidget {
  final int currentDay;
  final List<String> days;
  // Esta función sirve para avisarle al padre que tocaron un botón
  final ValueChanged<int> onDaySelected;

  const WeekRow({
    super.key,
    required this.days,
    required this.currentDay,
    required this.onDaySelected, // Requerimos la función
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.asMap().entries.map((entry) {
          int index = entry.key;
          String dayName = entry.value;
          bool isSelected = index == currentDay;

          return Expanded(
            // El GestureDetector es lo que lo convierte en BOTÓN
            child: GestureDetector(
              onTap: () {
                // Al tocar, ejecutamos la función pasando el índice de este botón
                onDaySelected(index);
              },
              child: AnimatedContainer(
                // Usé AnimatedContainer para que el cambio de color sea suave
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(color: Colors.white24),
                ),
                child: Text(
                  dayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
