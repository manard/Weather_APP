import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'city.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  List<City> cities = []; // List to store city data

  @override
  void initState() {
    super.initState();
    fetchWeatherDataForCities();
  }

  fetchWeatherDataForCities() async {
    List<String> cityNames = ['London', 'Paris', 'New York']; // Example cities
    final apiKey = '7a8d911a170646f2852100137241207'; // Your API key

    for (String city in cityNames) {
      final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var weatherData = json.decode(response.body);
        var cityData = City(
          name: weatherData['location']['name'],
          temperature: weatherData['current']['temp_c'],
          weatherCondition: weatherData['current']['condition']['text'],
          weatherIconUrl: 'http:${weatherData['current']['condition']['icon']}',
        );
        setState(() {
          cities.add(cityData);
        });
      } else {
        print("Failed to load weather data for $city");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Places'),
      ),
      body: cities.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                var city = cities[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      city.weatherIconUrl,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(city.name),
                    subtitle: Text('${city.temperature}°C, ${city.weatherCondition}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Navigate to more info screen or show more details
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CityDetailsScreen(city: city)),
                        );
                      },
                      child: Text('Info'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class CityDetailsScreen extends StatelessWidget {
  final City city;

  const CityDetailsScreen({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(city.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              city.weatherIconUrl,
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text('Temperature: ${city.temperature}°C'),
            SizedBox(height: 10),
            Text('Weather: ${city.weatherCondition}'),
          ],
        ),
      ),
    );
  }
}
