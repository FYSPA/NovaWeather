import 'package:flutter/material.dart';

class CityWeatherCard extends StatelessWidget {
  final String temperature;
  final String city;
  final String highLow; // Ejemplo: "H:24° L:18°"
  final String condition; // Ejemplo: "Mid Rain"
  final String iconPath; // Ruta de tu imagen 3D

  const CityWeatherCard({
    super.key,
    required this.temperature,
    required this.city,
    required this.highLow,
    required this.condition,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, // Altura fija como en el diseño
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Stack(
        children: [
          // ---------------------------------------------------------
          // CAPA 1: EL FONDO CON GRADIENTE Y FORMA
          // ---------------------------------------------------------
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), // Bordes muy redondos
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF5936B4), // Morado vibrante (Arriba izquierda)
                  Color(0xFF362A84), // Azul oscuro (Abajo derecha)
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  offset: const Offset(5, 5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),

          // ---------------------------------------------------------
          // CAPA 2: DECORACIÓN DE FONDO (La ola/montaña)
          // ---------------------------------------------------------
          /* 
             Nota: En el diseño original, esto es una imagen vectorial (SVG).
             Aquí usamos un Positioned con un color suave para simularlo,
             pero lo ideal es exportar esa forma desde Figma como 'bg_shape.png'.
          */
          Positioned(
            right: 0,
            bottom: 0,
            left: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05), // Muy sutil
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(100), // Curva simulada
                ),
              ),
            ),
          ),

          // ---------------------------------------------------------
          // CAPA 3: EL CONTENIDO (Texto e Icono)
          // ---------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // COLUMNA IZQUIERDA (Textos)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Temperatura Grande
                    Text(
                      temperature,
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.0, // Reduce el espacio extra de la fuente
                      ),
                    ),

                    // Ciudad y Máx/Mín
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          highLow,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: .6),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          city,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // COLUMNA DERECHA (Icono y Condición)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Icono 3D
                    SizedBox(
                      width: 120, // Tamaño grande
                      height: 100,
                      child: Image.asset(iconPath, fit: BoxFit.contain),
                    ),

                    // Texto de condición (ej. Mid Rain)
                    Text(
                      condition,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
