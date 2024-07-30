import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'daily_forecast_screen.dart';
import 'hourly_forecast_screen.dart';
import 'places_screen.dart'; // Import your places screen here

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cityName = "London"; // Default city
  var weatherData;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWeatherData(cityName);
  }

  fetchWeatherData(String city) async {
    print("Fetching weather data for $city...");
    final apiKey = '7a8d911a170646f2852100137241207'; // Your API key
    final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Weather data fetched successfully");
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      print("Failed to load weather data");
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Weather App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home Screen'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Home Screen (refresh)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Daily Forecast Screen'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Daily Forecast Screen with cityName parameter
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DailyForecastScreen(cityName: cityName),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Hourly Forecast Screen'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Hourly Forecast Screen with cityName parameter
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HourlyForecastScreen(cityName: cityName),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Places Screen'), // Change as per your screen title
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Places Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlacesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                setState(() {
                  cityName = value;
                });
                fetchWeatherData(cityName);
              },
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  cityName = _controller.text;
                });
                fetchWeatherData(cityName);
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            weatherData == null
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text(
                        weatherData['location']['name'],
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        '${weatherData['current']['temp_c']}°C',
                        style: TextStyle(fontSize: 48),
                      ),
                      Text(
                        weatherData['current']['condition']['text'],
                        style: TextStyle(fontSize: 24),
                      ),
                      Image.network(
                        'http:${weatherData['current']['condition']['icon']}',
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
