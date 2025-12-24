import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wheatherapp/models/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Obtener Clima Actual (Un solo objeto Weather)
  Future<Weather> getWeather(String cityName) async {
    final String? apiKey = dotenv.env['WEATHERAPI'];
    if (apiKey == null) throw Exception('API Key no encontrada');

    final response = await http.get(
      Uri.parse('$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error actual: ${response.statusCode}');
    }
  }

  // Obtener Pronóstico (Lista de objetos Weather)
  Future<List<Weather>> getForecast(String cityName) async {
    final String? apiKey = dotenv.env['WEATHERAPI'];
    // Nota: endpoint /forecast
    final response = await http.get(
      Uri.parse('$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List list = json['list'];
      // Convertimos la lista JSON a lista de Weather
      return list.map((item) => Weather.fromJson(item)).toList();
    } else {
      throw Exception('Error forecast: ${response.statusCode}');
    }
  }

  Future<List<String>> getCountries() async {
    try {
      final url = Uri.parse(
        'https://restcountries.com/v3.1/all?fields=name,cca2',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Extraemos los nombres comunes de los países
        List<String> countries = data.map((item) {
          return item['name']['common'].toString();
        }).toList();

        // Los ordenamos alfabéticamente para que sea fácil buscar
        countries.sort();

        return countries;
      } else {
        return ['Mexico', 'USA', 'Canada']; // Lista de respaldo si falla
      }
    } catch (e) {
      print("Error cargando países: $e");
      return ['Mexico', 'USA', 'Canada']; // Lista de respaldo
    }
  }

  Future<List<String>> getCities(String countryName) async {
    try {
      // CAMBIO 1: La URL ahora incluye el país al final
      final url = Uri.parse(
        'https://countriesnow.space/api/v0.1/countries/cities/q?country=$countryName',
      );

      // CAMBIO 2: Usamos GET en lugar de POST y quitamos el body
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        // Verificamos si la API dice que hubo error lógico
        if (json['error'] == true) {
          return [];
        }

        final List<dynamic> citiesData = json['data'];
        return citiesData.map((city) => city.toString()).toList();
      } else {
        print("Error API: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error cargando ciudades: $e");
      return [];
    }
  }
}
