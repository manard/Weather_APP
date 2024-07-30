import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DailyForecastScreen extends StatefulWidget {
  final String cityName;

  const DailyForecastScreen({Key? key, required this.cityName}) : super(key: key);

  @override
  _DailyForecastScreenState createState() => _DailyForecastScreenState();
}

class _DailyForecastScreenState extends State<DailyForecastScreen> {
  var forecastData;

  @override
  void initState() {
    super.initState();
    fetchForecastData(widget.cityName);
  }

  fetchForecastData(String city) async {
    print("Fetching forecast data for $city...");
    final apiKey = '7a8d911a170646f2852100137241207'; // Your API key
    final url = 'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Forecast data fetched successfully");
      setState(() {
        forecastData = json.decode(response.body);
      });
    } else {
      print("Failed to load forecast data");
      throw Exception('Failed to load forecast data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Forecast for ${widget.cityName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: forecastData == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: forecastData['forecast']['forecastday'].length,
                itemBuilder: (context, index) {
                  var forecast = forecastData['forecast']['forecastday'][index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        'http:${forecast['day']['condition']['icon']}',
                        width: 50,
                        height: 50,
                      ),
                      title: Text(forecast['date']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${forecast['day']['condition']['text']}',
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'High: ${forecast['day']['maxtemp_c']}°C',
                              ),
                              Text(
                                'Low: ${forecast['day']['mintemp_c']}°C',
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.open_in_browser),
                        onPressed: () {
                          // Open weather map link
                          var weatherMapUrl = 'https://www.weathermap.com/';
                          // Example URL, replace with actual weather map link
                          // Open the URL in a web browser
                          // You can use plugins like url_launcher for this purpose.
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
