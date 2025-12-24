import 'package:flutter/material.dart';

class AppColors {
  // Tu color azul oscuro
  static const Color mainBackground = Color.fromARGB(255, 34, 38, 100);

  // Color para el texto principal
  static const Color primaryText = Colors.white;

  // Color para los bordes del vidrio
  static const Color glassBorder = Color(0x4DFFFFFF); // Blanco con 30% opacidad

  static const Color backgroundCards = Color(0xFF696589);

  // Gradiente para el fondo
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 0, 16, 239), // Un azul un poco más claro arriba
      Color(0xFF0B0C1E), // Tu color oscuro abajo
    ],
  );
}
