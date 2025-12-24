class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final DateTime date;
  final double windSpeed;
  final int humidity;
  final DateTime sunrise;
  final DateTime sunset;
  final double precipitationProb;
  final double minTemp;
  final double maxTemp;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.date,
    required this.windSpeed,
    required this.humidity,
    required this.sunrise,
    required this.sunset,
    required this.precipitationProb,
    required this.minTemp,
    required this.maxTemp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      date: json['dt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: false)
          : DateTime.now(),

      // --- MAPEO DE NUEVOS CAMPOS ---
      // Viento
      windSpeed: json['wind'] != null ? json['wind']['speed'].toDouble() : 0.0,
      // Humedad
      humidity: json['main'] != null ? json['main']['humidity'] : 0,
      // Amanecer y Atardecer (Vienen en 'sys' solo en /weather, no en /forecast)
      sunrise: json['sys'] != null && json['sys']['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['sys']['sunrise'] * 1000,
              isUtc: false,
            )
          : DateTime.now(),
      sunset: json['sys'] != null && json['sys']['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['sys']['sunset'] * 1000,
              isUtc: false,
            )
          : DateTime.now(),
      precipitationProb: json['pop'] != null ? json['pop'].toDouble() : 0.0,
      minTemp: json['main']['temp_min'].toDouble(),
      maxTemp: json['main']['temp_max'].toDouble(),
    );
  }
}
