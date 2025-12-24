import 'package:flutter/material.dart';
import 'package:wheatherapp/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Esta línea CARGA el archivo .env
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme:
          ThemeData.dark(), // Tema oscuro por defecto para que se vea elegante
      home: const MainScreen(),
    );
  }
}
