import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String temperature;
  final String location;
  final String imagePath;

  const WeatherCard({
    super.key,
    required this.temperature,
    required this.location,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // Margen externo para que el Stack tenga espacio de dibujarse
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Stack(
          clipBehavior:
              Clip.none, // PERMITE QUE LOS HIJOS SALGAN DEL CONTENEDOR
          children: [
            // 1. EL CONTENEDOR OSCURO (LA TARJETA)
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 160,
              padding: const EdgeInsets.only(
                left: 140,
                right: 20,
                top: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ), // Borde sutil
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        temperature,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. LA IMAGEN POSICIONADA (LA QUE SOBRESALE)
            Positioned(
              left: 10, // Se sale 10 píxeles a la izquierda
              top: -60, // Se sale 30 píxeles hacia arriba
              child: SizedBox(
                width: 250,
                height: 250,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
