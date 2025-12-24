import 'package:flutter/material.dart';

class ProfileUser extends StatelessWidget {
  const ProfileUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                width: 250,
                margin: EdgeInsets.all(10),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/weather/sunny.png',
                  ),
                ),
              ),
              Positioned(
                bottom: 5, // Pegado abajo
                right: 20, // Pegado a la derecha
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33).withValues(alpha: .5),
                    shape: BoxShape.circle, // Botón redondo
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      print("Cambiar foto");
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "(Name User)",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
