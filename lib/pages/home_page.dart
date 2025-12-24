import 'package:flutter/material.dart';
import 'package:wheatherapp/widgets/weather_card.dart';
import 'package:wheatherapp/widgets/week_row.dart';
import 'package:wheatherapp/widgets/buildHourlySection.dart';
import 'package:wheatherapp/widgets/hour_weather.dart';
import 'package:wheatherapp/widgets/draggable_scroll.dart'; // Importa el draggable
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheatherapp/models/weather_model.dart';
import 'package:wheatherapp/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();

  Weather? _currentWeather;
  List<Weather> _forecastList = [];
  bool _isLoading = true;

  // VARIABLES DE PREFERENCIA
  bool _isCelsius = true;
  String _windUnit = 'km/h';
  bool _is24Hour = false;

  final List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];
  int _diaSeleccionado = 0;
  int _todayIndex = 0;
  @override
  void initState() {
    super.initState();
    _todayIndex = DateTime.now().weekday - 1;

    // Al inicio, el día seleccionado es hoy
    _diaSeleccionado = _todayIndex;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      String ciudad = prefs.getString('user_city') ?? "Mexico City";

      // LEER PREFERENCIAS
      bool celsiusPref = prefs.getBool('is_celsius') ?? true;
      String windPref = prefs.getString('wind_unit') ?? 'km/h';
      bool timePref = prefs.getBool('is_24_hour') ?? false;

      final current = await _weatherService.getWeather(ciudad);
      final forecast = await _weatherService.getForecast(ciudad);

      setState(() {
        _currentWeather = current;
        _forecastList = forecast;
        _isCelsius = celsiusPref;
        _windUnit = windPref; // Guardamos
        _is24Hour = timePref; // Guardamos
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  String _getTemp(double celsius) {
    if (_isCelsius)
      return '${celsius.round()}°C';
    else
      return '${((celsius * 9 / 5) + 32).round()}°F';
  }

  String _getWeatherIcon(String? condition) {
    if (condition == null) return 'assets/images/weather/sunny.png';
    final c = condition.toLowerCase();
    if (c.contains('rain')) return 'assets/images/weather/rainy.png';
    if (c.contains('cloud')) return 'assets/images/weather/cloudy.png';
    if (c.contains('clear')) return 'assets/images/weather/sunny.png';
    if (c.contains('thunder')) return 'assets/images/weather/thunder.png';
    return 'assets/images/weather/sunny.png';
  }

  List<Weather> _getForecastForSelectedDay() {
    if (_forecastList.isEmpty) return [];
    final now = DateTime.now();
    final targetDate = now.add(Duration(days: _diaSeleccionado));
    return _forecastList
        .where((item) => item.date.day == targetDate.day)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );

    final selectedDayForecast = _getForecastForSelectedDay();

    return Container(
      padding: const EdgeInsets.all(30.0),
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Stack(
        // Usamos Stack para que el Draggable funcione
        children: [
          // 1. CONTENIDO PRINCIPAL (Scroll)
          RefreshIndicator(
            onRefresh: _loadData,
            color: Colors.white,
            backgroundColor: Colors.blueAccent,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),

                  if (_currentWeather != null)
                    WeatherCard(
                      temperature: _getTemp(_currentWeather!.temperature),
                      location: _currentWeather!.cityName,
                      imagePath: _getWeatherIcon(
                        _currentWeather!.mainCondition,
                      ),
                    ),

                  const SizedBox(height: 30),

                  WeekRow(
                    days: _diasSemana,
                    currentDay: _diaSeleccionado,
                    todayIndex:
                        _todayIndex, // <--- 2. Pasamos el índice fijo de hoy
                    onDaySelected: (index) =>
                        setState(() => _diaSeleccionado = index),
                  ),

                  const SizedBox(height: 30),

                  if (_forecastList.isNotEmpty)
                    HourlySection(
                      title: "Próximas Horas",
                      weatherCards: _forecastList.take(5).map((item) {
                        return Row(
                          children: [
                            HourWeatherPill(
                              temperature: _getTemp(item.temperature),
                              hour: item.date.hour,
                              imagePath: _getWeatherIcon(item.mainCondition),
                              isActive: item == _forecastList.first,
                            ),
                            const SizedBox(width: 10),
                          ],
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 30),

                  if (selectedDayForecast.isNotEmpty)
                    HourlySection(
                      title: "Pronóstico ${_diasSemana[_diaSeleccionado]}",
                      weatherCards: selectedDayForecast.map((item) {
                        return Row(
                          children: [
                            HourWeatherPill(
                              temperature: _getTemp(item.temperature),
                              hour: item.date.hour,
                              imagePath: _getWeatherIcon(item.mainCondition),
                            ),
                            const SizedBox(width: 10),
                          ],
                        );
                      }).toList(),
                    )
                  else
                    const Center(
                      child: Text(
                        "No hay datos disponibles",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),

                  const SizedBox(
                    height: 100,
                  ), // Espacio extra para que no tape el Draggable
                ],
              ),
            ),
          ),

          // 2. EL DRAGGABLE SCROLL (Ahora recibe las preferencias)
          if (_currentWeather != null)
            DraggableScroll(
              weather: _currentWeather,
              forecastList: _forecastList,
              windUnit: _windUnit, // Pasamos unidad
              is24Hour: _is24Hour, // Pasamos formato
            ),
        ],
      ),
    );
  }
}
