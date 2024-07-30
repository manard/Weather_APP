import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cityName = "London";
  var weatherData;

  @override
  void initState() {
    super.initState();
    print("InitState: Fetching weather data for $cityName");
    fetchWeatherData(cityName);
  }

  fetchWeatherData(String city) async {
    print("Fetching weather data...");
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
      body: weatherData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
