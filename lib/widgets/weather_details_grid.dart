import 'package:flutter/material.dart';
import 'package:wheatherapp/widgets/info_card.dart';
import 'package:wheatherapp/models/weather_model.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final Weather? weather;
  final List<Weather> forecast;
  final String windUnit; // 'km/h', 'mph', 'm/s'
  final bool is24Hour;

  const WeatherDetailsGrid({
    super.key,
    required this.weather,
    this.forecast = const [],
    this.windUnit = 'km/h',
    this.is24Hour = false,
  });

  // --- LOGICA DE FORMATO DE HORA (12h vs 24h) ---
  String _formatTime(DateTime time) {
    if (is24Hour) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    } else {
      final hour = time.hour > 12
          ? time.hour - 12
          : (time.hour == 0 ? 12 : time.hour);
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return "$hour:$minute $period";
    }
  }

  // --- LOGICA DE TEXTO DE VIENTO ---
  String _getWindText() {
    double speed = weather!.windSpeed; // La API suele dar m/s
    double finalSpeed = speed;

    if (windUnit == 'km/h') {
      finalSpeed = speed * 3.6;
    } else if (windUnit == 'mph') {
      finalSpeed = speed * 2.23694;
    }

    return "${finalSpeed.toStringAsFixed(1)} $windUnit";
  }

  // --- LOGICA VISUAL DE BARRA DE VIENTO (0 a 1.0) ---
  double _getWindPercent() {
    // Asumimos que 100 km/h (o 28 m/s) es el máximo para la barra llena
    // Ajusta este 28.0 si quieres que la barra se llene con menos viento
    return (weather!.windSpeed / 28.0).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    if (weather == null) return const SizedBox();

    return Column(
      children: [
        // ------------------------------------------------
        // 1. TARJETA VIENTO (Diseño Restaurado)
        // ------------------------------------------------
        SizedBox(
          height: 140,
          width: double.infinity,
          child: InfoCard(
            title: "WIND SPEED",
            icon: Icons.air,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getWindText(), // Texto convertido (ej. 15 km/h)
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // AQUÍ ESTÁ EL DISEÑO DE LA BARRA QUE FALTABA
                Stack(
                  children: [
                    // Fondo de la barra (Gris transparente)
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    // Relleno de la barra (Gradiente)
                    FractionallySizedBox(
                      widthFactor:
                          _getWindPercent(), // Se llena según la velocidad
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.purple, Colors.pink],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Intensidad", style: TextStyle(color: Colors.white70)),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 15),

        // ------------------------------------------------
        // 2. FILA CENTRAL (HUMEDAD Y SOL)
        // ------------------------------------------------
        Row(
          children: [
            // HUMEDAD
            Expanded(
              child: SizedBox(
                height: 160,
                child: InfoCard(
                  title: "HUMIDITY",
                  icon: Icons.water_drop_outlined,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${weather!.humidity}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Humedad",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const Spacer(),
                      // Barra de humedad
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: weather!.humidity / 100,
                          backgroundColor: Colors.white10,
                          color: Colors.purpleAccent,
                          minHeight: 5,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 15),

            // AMANECER / ATARDECER
            Expanded(
              child: SizedBox(
                height: 160,
                child: InfoCard(
                  title: "SUNRISE",
                  icon: Icons.wb_twilight,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatTime(weather!.sunrise),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Sunset: ${_formatTime(weather!.sunset)}",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.waves,
                        color: Colors.purpleAccent,
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // ------------------------------------------------
        // 3. PRECIPITACIÓN (Gráfica de barras)
        // ------------------------------------------------
        SizedBox(
          height: 250,
          width: double.infinity,
          child: InfoCard(
            title: "PRECIPITACIÓN",
            icon: Icons.water_drop,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pronóstico", // Título genérico si no tenemos el % exacto
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Próximas horas",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Spacer(),

                // Gráfica
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (forecast.isEmpty)
                      const Text(
                        "Cargando...",
                        style: TextStyle(color: Colors.white54),
                      )
                    else
                      ...forecast.take(6).map((item) {
                        return _buildRainBar(
                          _formatTime(item.date),
                          item.precipitationProb,
                        );
                      }),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Widget auxiliar para las barritas de lluvia
Widget _buildRainBar(String time, double percentage) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 16,
        // Altura mínima 4 para que se vea algo aunque sea 0%
        height: (60 * percentage).clamp(4.0, 60.0),
        decoration: BoxDecoration(
          color: percentage > 0.5
              ? Colors.purpleAccent
              : Colors.blue.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.blue.withValues(alpha: 0.5), Colors.purpleAccent],
          ),
        ),
      ),
      const SizedBox(height: 8),
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          time,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ),
    ],
  );
}
