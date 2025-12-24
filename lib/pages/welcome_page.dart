import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheatherapp/main_screen.dart'; // Importa tu pantalla principal

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // Función para guardar la decisión y navegar
  Future<void> _selectMode(BuildContext context, bool use3D) async {
    final prefs = await SharedPreferences.getInstance();
    // Guardamos: true = 3D, false = 2D
    await prefs.setBool('is_3d_mode', use3D);
    await prefs.setBool('is_first_time', false); // Ya no es la primera vez

    // Vamos a la pantalla principal y borramos la bienvenida del historial
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bienvenido a NovaWeather",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Elige tu experiencia:",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 50),

            // OPCIÓN 1: MODO 3D
            _buildOptionCard(
              context,
              title: "Modo 3D (Inmersivo)",
              subtitle: "Mejor visual, requiere celular potente.",
              icon: Icons.view_in_ar,
              color: Colors.blue,
              is3D: true,
            ),

            const SizedBox(height: 20),

            // OPCIÓN 2: MODO 2D
            _buildOptionCard(
              context,
              title: "Modo 2D (Rápido)",
              subtitle: "Ahorra batería, ideal para todo celular.",
              icon: Icons.image,
              color: Colors.green,
              is3D: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool is3D,
  }) {
    return GestureDetector(
      onTap: () => _selectMode(context, is3D),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white30,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
