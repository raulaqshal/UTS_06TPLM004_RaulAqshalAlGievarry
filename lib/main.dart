import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'weather_service.dart';
import 'weather_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  final TextEditingController _controller = TextEditingController(text: 'Harlem');

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    try {
      final weather = await _weatherService.fetchWeather(_controller.text);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = [
      "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ];
    final months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${weekdays[now.weekday % 7]}, ${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: _weather == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center,  // Center horizontally
          children: [
            const SizedBox(height: 30),

            Text(
              _weather!.cityName,
              style: const TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,  // Center text horizontally
            ),
            const SizedBox(height: 8),

            Text(
              _getFormattedDate(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,  // Center text horizontally
            ),
            const SizedBox(height: 30),

            Text(
              "${_weather!.temperature.toStringAsFixed(0)}°C",
              style: const TextStyle(
                fontSize: 100,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,  // Center text horizontally
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(20, (index) {
                return Container(
                  width: 5,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: Colors.white,
                );
              }),
            ),
            const SizedBox(height: 16),

            Text(
              _weather!.description[0].toUpperCase() + _weather!.description.substring(1),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,  // Center text horizontally
            ),
            const SizedBox(height: 10),

            const Text(
              "25°C / 28°C",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,  // Center text horizontally
            ),
          ],
        ),
      ),
    );
  }
}
