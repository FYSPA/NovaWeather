import 'package:flutter/material.dart';
import 'package:wheatherapp/services/weather_service.dart';
import 'package:wheatherapp/widgets/user/location_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final WeatherService _weatherService = WeatherService();

  // Preferencias
  String? _paisSeleccionado;
  String? _ciudadSeleccionada;
  bool _isCelsius = true;
  String _windUnit = 'km/h'; // 'km/h', 'mph', 'm/s'
  bool _is24Hour = false; // false = 12h, true = 24h

  // Datos API
  List<String> _paises = [];
  List<String> _ciudades = [];
  bool _isLoadingPaises = true;
  bool _isLoadingCiudades = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCelsius = prefs.getBool('is_celsius') ?? true;
      _windUnit = prefs.getString('wind_unit') ?? 'km/h';
      _is24Hour = prefs.getBool('is_24_hour') ?? false;
    });
  }

  Future<void> _loadCountries() async {
    final countries = await _weatherService.getCountries();
    if (mounted) {
      setState(() {
        _paises = countries;
        _isLoadingPaises = false;
      });
    }
  }

  Future<void> _loadCities(String pais) async {
    setState(() {
      _isLoadingCiudades = true;
      _ciudades = [];
      _ciudadSeleccionada = null;
    });

    List<String> cities = await _weatherService.getCities(pais);

    // Respaldo simple
    if (cities.isEmpty) {
      if (pais == "Mexico")
        cities = ["Mexico City", "Guadalajara", "Monterrey"];
      else
        cities = ["Capital City"];
    }

    if (mounted) {
      setState(() {
        _ciudades = cities;
        _isLoadingCiudades = false;
      });
    }
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
          colors: [Color(0xFF2C3E50), Color(0xFF000000)],
        ),
      ),
      child: SafeArea(
        child: _isLoadingPaises
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Configuración',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Personaliza tu experiencia',
                      style: TextStyle(fontSize: 16, color: Colors.white54),
                    ),

                    const SizedBox(height: 40),

                    // UNIDADES
                    _buildSectionTitle("Temperatura"),
                    _buildToggleRow([
                      _buildUnitToggle(
                        "Celsius (°C)",
                        _isCelsius,
                        () => setState(() => _isCelsius = true),
                      ),
                      _buildUnitToggle(
                        "Fahrenheit (°F)",
                        !_isCelsius,
                        () => setState(() => _isCelsius = false),
                      ),
                    ]),

                    const SizedBox(height: 20),

                    _buildSectionTitle("Viento"),
                    _buildToggleRow([
                      _buildUnitToggle(
                        "km/h",
                        _windUnit == 'km/h',
                        () => setState(() => _windUnit = 'km/h'),
                      ),
                      _buildUnitToggle(
                        "mph",
                        _windUnit == 'mph',
                        () => setState(() => _windUnit = 'mph'),
                      ),
                      _buildUnitToggle(
                        "m/s",
                        _windUnit == 'm/s',
                        () => setState(() => _windUnit = 'm/s'),
                      ),
                    ]),

                    const SizedBox(height: 20),

                    _buildSectionTitle("Formato de Hora"),
                    _buildToggleRow([
                      _buildUnitToggle(
                        "12h (AM/PM)",
                        !_is24Hour,
                        () => setState(() => _is24Hour = false),
                      ),
                      _buildUnitToggle(
                        "24h (14:00)",
                        _is24Hour,
                        () => setState(() => _is24Hour = true),
                      ),
                    ]),

                    const SizedBox(height: 30),

                    // UBICACIÓN
                    _buildSectionTitle("Ubicación por defecto"),
                    LocationSelector(
                      label: "País",
                      icon: Icons.public,
                      options: _paises,
                      selectedValue: _paisSeleccionado,
                      isLoading: _isLoadingPaises,
                      onSelected: (val) {
                        setState(() => _paisSeleccionado = val);
                        _loadCities(val);
                      },
                    ),
                    const SizedBox(height: 20),
                    LocationSelector(
                      label: "Ciudad",
                      icon: Icons.location_city,
                      options: _ciudades,
                      selectedValue: _ciudadSeleccionada,
                      isLoading: _isLoadingCiudades,
                      onSelected: (val) =>
                          setState(() => _ciudadSeleccionada = val),
                    ),

                    const SizedBox(height: 50),

                    // BOTÓN GUARDAR
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          if (_ciudadSeleccionada != null) {
                            await prefs.setString(
                              'user_city',
                              _ciudadSeleccionada!,
                            );
                          }
                          await prefs.setBool('is_celsius', _isCelsius);
                          await prefs.setString('wind_unit', _windUnit);
                          await prefs.setBool('is_24_hour', _is24Hour);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Configuración guardada"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Guardar Cambios",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildToggleRow(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(children: children),
    );
  }

  Widget _buildUnitToggle(String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white54,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
