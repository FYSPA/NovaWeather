import 'package:flutter/material.dart';

class WeekRow extends StatelessWidget {
  final int currentDay; // El día que el usuario está viendo (seleccionado)
  final int todayIndex; // El día real (HOY)
  final List<String> days;
  final ValueChanged<int> onDaySelected;

  const WeekRow({
    super.key,
    required this.days,
    required this.currentDay,
    required this.todayIndex, // <--- Nuevo parámetro obligatorio
    required this.onDaySelected,
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

          // Lógica de estados
          bool isSelected = index == currentDay;
          bool isToday = index == todayIndex;

          // Definimos colores según el estado
          Color backgroundColor;
          Color textColor;
          BoxBorder? border;

          if (isSelected) {
            // ESTADO 1: Seleccionado (Prioridad)
            backgroundColor = Colors.white;
            textColor = Colors.black;
            border = null; // Sin borde, es relleno sólido
          } else if (isToday) {
            // ESTADO 2: Es HOY, pero NO está seleccionado
            backgroundColor = Colors.white.withValues(alpha: 0.15);
            textColor = Colors.white;
          } else {
            // ESTADO 3: Ni seleccionado ni hoy
            backgroundColor = Colors.white.withValues(alpha: 0.2);
            textColor = Colors.white;
            border = Border.all(color: Colors.white24);
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => onDaySelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: border, // Aplicamos el borde calculado arriba
                  boxShadow: (isToday && !isSelected)
                      ? [
                          BoxShadow(
                            color: Color.fromARGB(
                              255,
                              80,
                              50,
                              156,
                            ).withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ]
                      : null, // Opcional: un pequeño brillo si es hoy
                ),
                child: Column(
                  children: [
                    Text(
                      dayName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: isSelected || isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    // Opcional: Agregar un pequeño punto debajo si es HOY
                    if (isToday && !isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.orangeAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
