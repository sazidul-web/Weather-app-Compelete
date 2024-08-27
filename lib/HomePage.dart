import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whether_app/WeatherService.dart';
import 'dart:ui';
import 'forecaseSqeen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _Home();
}

class _Home extends State<Homepage> {
  final Weatherservice weatherservice = Weatherservice();
  Map<String, dynamic>? currentWeather;
  String _city = 'Dhaka';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weatherData = await weatherservice.fetchCurrentWeather(_city);
      setState(() {
        currentWeather = weatherData;
      });
    } catch (e) {
      print(e);
    }
  }

  void showcityselectiondilog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter city name'),
            content: TypeAheadField(
              suggestionsCallback: (Pattern) async {
                return await weatherservice.fetchcitysujation(Pattern);
              },
              builder: (context, controller, FocusNode) {
                return TextField(
                  controller: controller,
                  focusNode: FocusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City',
                  ),
                );
              },
              itemBuilder: (context, suggestions) {
                return ListTile(
                  title: Text(suggestions['name']),
                );
              },
              onSelected: (city) {
                setState(() {
                  _city = city['name'];
                });
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _fetchWeather();
                  },
                  child: Text('Done'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentWeather == null
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A2344),
                    Color.fromARGB(255, 125, 32, 142),
                    Colors.purple,
                    Color.fromARGB(255, 155, 44, 170),
                  ],
                ),
              ),
              child: ListView(
                children: [
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: showcityselectiondilog,
                    child: Text(
                      _city,
                      style: GoogleFonts.lato(
                        fontSize: 36.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  if (currentWeather != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https:${currentWeather!['current']['condition']['icon']}',
                          height: 100.w,
                          width: 100.w,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          '${currentWeather!['current']['temp_c'].round()}°C',
                          style: GoogleFonts.lato(
                              fontSize: 36.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${currentWeather!['current']['condition']['text']}',
                          style: GoogleFonts.lato(
                              fontSize: 36.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                                'Max: ${currentWeather!['forecast']['forecastday'][0]['day']['maxtemp_c'].round()}°C',
                                style: GoogleFonts.lato(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Text(
                                'Min: ${currentWeather!['forecast']['forecastday'][0]['day']['mintemp_c'].round()}°C',
                                style: GoogleFonts.lato(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ],
                        )
                      ],
                    ),
                  SizedBox(
                    height: 45.h,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherDetail(
                            'Sunrise',
                            Icons.wb_sunny,
                            currentWeather!['forecast']['forecastday'][0]
                                ['astro']['sunrise']),
                        _buildWeatherDetail(
                            'Sunset',
                            Icons.brightness_3,
                            currentWeather!['forecast']['forecastday'][0]
                                ['astro']['sunset']),
                      ]),
                  SizedBox(height: 20.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherDetail('Humidity', Icons.opacity,
                            currentWeather!['current']['humidity']),
                        _buildWeatherDetail('Wind kph', Icons.wind_power,
                            currentWeather!['current']['wind_kph']),
                      ]),
                  SizedBox(
                    height: 40.h,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForecaseScreen(city: _city),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A2344),
                      ),
                      child: Text(
                        'Next 7 days forecast',
                        style: TextStyle(fontSize: 20.sp, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

Widget _buildWeatherDetail(String label, IconData icon, dynamic value) {
  return ClipRRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3,
        sigmaY: 3,
      ),
      child: Container(
        padding: EdgeInsets.all(5.r),
        height: 110.h,
        width: 110.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  Color(0xFF1A2344).withOpacity(0.5),
                  Color(0xFF1A2344).withOpacity(0.2),
                ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(label,
                style: GoogleFonts.lato(
                  fontSize: 22.sp,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                )),
            Text(
              value is String ? value : value.toString(),
              style: GoogleFonts.lato(
                  fontSize: 22.sp,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ),
  );
}
