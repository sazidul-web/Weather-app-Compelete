import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'WeatherService.dart';
import 'dart:ui';

class ForecaseScreen extends StatefulWidget {
  final String city;
  const ForecaseScreen({required this.city});

  @override
  _ForecaseScreenState createState() => _ForecaseScreenState();
}

class _ForecaseScreenState extends State<ForecaseScreen> {
  final Weatherservice weatherservice = Weatherservice();
  List<dynamic>? _forecast;

  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }

  Future<void> _fetchForecast() async {
    try {
      final forecastData = await weatherservice.fetch7daysWeather(widget.city);
      setState(() {
        _forecast = forecastData['forecast']['forecastday'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _forecast == null
            ? Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
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
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30.r,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Text(
                            '7 days forecast',
                            style: GoogleFonts.lato(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _forecast?.length ?? 0,
                        itemBuilder: (context, index) {
                          final day = _forecast![index];
                          String iconUrl =
                              'http:${day['day']['condition']['icon']}';
                          return Padding(
                            padding: EdgeInsets.all(10.r),
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Container(
                                  padding: EdgeInsets.all(5.h),
                                  height: 110.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    gradient: LinearGradient(
                                      begin: AlignmentDirectional.topStart,
                                      end: AlignmentDirectional.bottomEnd,
                                      colors: [
                                        Color(0xFF1A2344).withOpacity(0.5),
                                        Color(0xFF1A2344).withOpacity(0.2),
                                      ],
                                    ),
                                  ),
                                  child: ListTile(
                                      leading: Image.network(iconUrl),
                                      title: Text(
                                        '${day['date']}\n${day['day']['avgtemp_c'].round()}°C',
                                        style: TextStyle(
                                            fontSize: 16.50.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        day['day']['condition']['text'],
                                        style: GoogleFonts.lato(
                                            fontSize: 12.sp,
                                            color: Colors.white),
                                      ),
                                      trailing: Text(
                                        'Max:${day['day']['maxtemp_c']}°C\nMin:${day['day']['mintemp_c']}°C',
                                        style: GoogleFonts.lato(
                                            fontSize: 13.sp,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
