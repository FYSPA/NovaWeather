import 'package:flutter/material.dart';
import 'package:wheatherapp/widgets/weather_details_grid.dart';
// 1. IMPORTA TU MODELO
import 'package:wheatherapp/models/weather_model.dart';

class DraggableScroll extends StatefulWidget {
  final Weather? weather;
  final List<Weather> forecastList;
  final String windUnit;
  final bool is24Hour;

  const DraggableScroll({
    super.key,
    this.weather,
    this.forecastList = const [],
    this.windUnit = 'km/h',
    this.is24Hour = false,
  });

  @override
  State<DraggableScroll> createState() => _WeatherBottomSheetState();
}

class _WeatherBottomSheetState extends State<DraggableScroll> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.85,
      builder: (BuildContext context, ScrollController scrollController) {
        return AnimatedBuilder(
          animation: _sheetController,
          builder: (context, child) {
            double currentSize = _sheetController.isAttached
                ? _sheetController.size
                : 0.1;
            double opacity = (currentSize - 0.1) / (1 - 0.1);
            opacity = opacity.clamp(0.0, 0.9);

            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1D1E33).withValues(
                  alpha: 0.2,
                ), // Le subí un poco la opacidad base para que se lea mejor al subir
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: opacity * 0.8),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 15, bottom: 15),
                        height: 5,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    Opacity(
                      opacity: opacity,
                      child: Column(
                        children: [
                          const Text(
                            "Información del Día",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            // 4. AQUÍ PASAMOS EL CLIMA AL GRID
                            // Usamos 'widget.weather' para acceder a la variable de arriba
                            child: WeatherDetailsGrid(
                              weather: widget.weather,
                              forecast: widget.forecastList,
                              windUnit: widget.windUnit,
                              is24Hour: widget.is24Hour,
                            ),
                          ),

                          const SizedBox(height: 50), // Espacio extra abajo
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
