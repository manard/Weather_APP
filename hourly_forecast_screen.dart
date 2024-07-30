import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HourlyForecastScreen extends StatefulWidget {
  final String cityName;

  const HourlyForecastScreen({Key? key, required this.cityName}) : super(key: key);

  @override
  _HourlyForecastScreenState createState() => _HourlyForecastScreenState();
}

class _HourlyForecastScreenState extends State<HourlyForecastScreen> {
  var hourlyForecastData;

  @override
  void initState() {
    super.initState();
    fetchHourlyForecastData(widget.cityName);
  }

  fetchHourlyForecastData(String city) async {
    print("Fetching hourly forecast data for $city...");
    final apiKey = '7a8d911a170646f2852100137241207'; // Your API key
    final url = 'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=1&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Hourly forecast data fetched successfully");
      setState(() {
        var data = json.decode(response.body);
        hourlyForecastData = data['forecast']['forecastday'][0]['hour'];
      });
    } else {
      print("Failed to load hourly forecast data");
      throw Exception('Failed to load hourly forecast data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hourly Forecast for ${widget.cityName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: hourlyForecastData == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: hourlyForecastData.length,
                itemBuilder: (context, index) {
                  var hourData = hourlyForecastData[index];
                  // Skip rendering the first item (assuming it's the date)
                  if (index == 0) return SizedBox.shrink();

                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        'http:${hourData['condition']['icon']}',
                        width: 50,
                        height: 50,
                      ),
                      title: Text(hourData['time']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${hourData['condition']['text']}'),
                          SizedBox(height: 5),
                          Text('Temperature: ${hourData['temp_c']}°C'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
