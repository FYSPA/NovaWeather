import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget content;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0x4D322361).withValues(alpha: 1), // Fondo oscuro
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1), // Borde sutil
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ENCABEZADO: Icono y Título
            Row(
              children: [
                Icon(icon, color: Colors.white54, size: 18),
                const SizedBox(width: 5),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // CONTENIDO: Lo que sea que le pasemos (Texto, barras, gráficas)
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
