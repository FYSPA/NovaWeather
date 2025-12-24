import 'package:flutter/material.dart';
import 'package:wheatherapp/widgets/search/city_weather_card.dart'; // Tu tarjeta
import 'package:wheatherapp/models/weather_model.dart';
import 'package:wheatherapp/services/weather_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controladores y Servicios
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  List<Weather> _randomCitiesWeather = [];
  bool _isLoadingRandom = true;

  final List<String> _popularCities = [
    'London',
    'Paris',
    'Madrid',
    'New York',
    'Tokyo',
    'Sydney',
    'Dubai',
    'Rome',
    'Berlin',
    'Moscow',
    'Rio de Janeiro',
    'Cairo',
    'Toronto',
    'Buenos Aires',
  ];

  Future<void> _loadRandomCities() async {
    try {
      // A. Mezclamos la lista para que siempre sean distintas
      _popularCities.shuffle();

      // B. Tomamos las primeras 3
      final citiesToFetch = _popularCities.take(3);

      List<Weather> results = [];

      // C. Pedimos el clima de cada una
      for (String city in citiesToFetch) {
        try {
          final weather = await _weatherService.getWeather(city);
          results.add(weather);
        } catch (e) {
          print("No se pudo cargar $city");
        }
      }

      // D. Actualizamos la pantalla
      if (mounted) {
        setState(() {
          _randomCitiesWeather = results;
          _isLoadingRandom = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // 3. Llamamos a la carga al iniciar
    _loadRandomCities();
  }

  // Estado
  Weather? _searchResult; // Aquí guardamos el clima encontrado
  bool _isLoading = false;
  String _errorMessage = '';

  // Función para buscar
  Future<void> _searchCity(String cityName) async {
    if (cityName.isEmpty) return;

    // Quitamos el teclado
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _searchResult = null; // Limpiamos resultado anterior
    });

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _searchResult = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "No se encontró la ciudad '$cityName'";
        _isLoading = false;
      });
    }
  }

  // Helper de iconos (Igual que en HomePage)
  String _getWeatherIcon(String? condition) {
    if (condition == null) return 'assets/images/weather/sunny.png';
    final c = condition.toLowerCase();
    if (c.contains('rain')) return 'assets/images/weather/rainy.png';
    if (c.contains('cloud')) return 'assets/images/weather/cloudy.png';
    if (c.contains('clear')) return 'assets/images/weather/sunny.png';
    if (c.contains('thunder')) return 'assets/images/weather/thunder.png';
    if (c.contains('wind'))
      return 'assets/images/weather/windy.png'; // Si tienes icono de viento
    return 'assets/images/weather/sunny.png';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 86, 63, 117),
            Color.fromARGB(255, 42, 25, 86),
          ],
        ),
      ),
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Buscar Ciudad',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // --- CAMPO DE BÚSQUEDA ---
                TextField(
                  controller: _searchController,
                  onSubmitted: (value) =>
                      _searchCity(value), // Buscar al dar Enter
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.15),
                    hintText: "Escribe una ciudad (ej. Madrid)...",
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),

                    // Botón de lupa que también busca al hacer clic
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () => _searchCity(_searchController.text),
                    ),

                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {}); // Para ocultar la X
                            },
                          )
                        : const Icon(Icons.mic, color: Colors.white),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        width: 2,
                        color: const Color.fromARGB(
                          255,
                          60,
                          43,
                          108,
                        ).withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // --- ESTADOS DE LA UI ---

                // 1. CARGANDO
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),

                // 2. ERROR
                if (_errorMessage.isNotEmpty)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                // 3. RESULTADO ENCONTRADO (Tarjeta Dinámica)
                if (_searchResult != null)
                  CityWeatherCard(
                    temperature: "${_searchResult!.temperature.round()}°",
                    city: _searchResult!.cityName,
                    // Usamos minTemp y maxTemp del modelo
                    highLow:
                        "H:${_searchResult!.maxTemp.round()}°  L:${_searchResult!.minTemp.round()}°",
                    condition: _searchResult!.mainCondition,
                    iconPath: _getWeatherIcon(_searchResult!.mainCondition),
                  ),

                // 4. LISTA DE EJEMPLOS (Opcional: Solo se ve si no has buscado nada aún)
                if (_searchResult == null &&
                    !_isLoading &&
                    _errorMessage.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sugerencias para ti",
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      // Si está cargando, mostramos un círculo
                      if (_isLoadingRandom)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),

                      // Si ya cargó, mostramos las tarjetas
                      ..._randomCitiesWeather.map((weather) {
                        return CityWeatherCard(
                          temperature: "${weather.temperature.round()}°",
                          city: weather.cityName,
                          // Usamos min/max reales
                          highLow:
                              "H:${weather.maxTemp.round()}°  L:${weather.minTemp.round()}°",
                          condition: weather.mainCondition,
                          iconPath: _getWeatherIcon(weather.mainCondition),
                        );
                      }),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
