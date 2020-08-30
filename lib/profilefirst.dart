import 'package:flutter_traveler_profile_app/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_traveler_profile_app/city_screen.dart';
import 'package:flutter_traveler_profile_app/Services/weather.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:async';
import 'dart:math';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'HomeScreen App',
              home: ProfileFirst(),
            );
          },
        );
      },
    );
  }
}

class ProfileFirst extends StatefulWidget {
  ProfileFirst({this.locationWeather});

  final locationWeather;

  @override
  _ProfileFirstState createState() => _ProfileFirstState();
}

class _ProfileFirstState extends State<ProfileFirst> {
  var list;
  var random;

//  var refreshKey = GlobalKey<RefreshIndicatorState>();
  WeatherModel weather = WeatherModel();
  int temperature;
  String weatherIcon;
  String cityName;
  String weatherMessage;
  String condition;

  int  feelsLike;
  int visibility;
  int pressure;
  int humidity;
  int mintemp;
  int maxtemp;
  int sunrise;
  int sunset;

  String country;
  String cityname;
  int lat;
  int lon;
  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }
//      double temp = weatherData['main']['temp'];
      temperature = weatherData['main']['temp'].toInt();
      feelsLike = weatherData['main']['feels_like'].toInt();
      visibility = weatherData['visibility'].toInt();
      mintemp = weatherData['main']['temp_min'].toInt();
      maxtemp = weatherData['main']['temp_max'].toInt();
      pressure = weatherData['main']['pressure'].toInt();
      humidity = weatherData['main']['humidity'].toInt();
      condition = weatherData['weather'][0]['main'];
      var condition1 = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition1);
      weatherMessage = weather.getMessage(temperature);
      cityName = weatherData['name'];
      sunrise = weatherData['sys']['sunrise'].toInt();
      sunset = weatherData['sys']['sunset'].toInt();
      lon =  weatherData['coord']['lon'].toInt();
      lat =  weatherData['coord']['lat'].toInt();
      country = weatherData['sys']['country'];
    print('${weatherData['main']['temp']}');
    });
  }
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8FA),
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[

          Container(
            color: Colors.blue[800],
            height: 50 * SizeConfig.heightMultiplier,
            child: Padding(
              padding:  EdgeInsets.only(left: 30.0, right: 30.0, top: 6 * SizeConfig.heightMultiplier),
              child: Column(
                children: <Widget>[
                  TextField(

                      onSubmitted: (value) async{
                        print('$value');
                        var weatherData = await WeatherModel().getCityWeather(value);
//                        print('${weatherData["coord"]["lon"]}');
//                        Navigator.push(
//                            context,
//                            PageTransition(
//                                type: PageTransitionType.fade,
//                                child: ProfileFirst(
//                                  locationWeather: weatherData,
//
//                                )
//                            ));
                      updateUI(weatherData);
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.black.withOpacity(0.1),
                          filled: true,
                          prefixIcon: Icon(Icons.search),
                          
                          hintText: 'Search something ...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.zero
                      )
                  ),
                  SizedBox(height: 3 * SizeConfig.heightMultiplier,),

                  Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Image.asset("assets/$weatherIcon.png", width: 100,),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              children: <Widget>[
                                Text('$temperature °C', style: TextStyle(
                                  fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white
                                ),),

                                Text('$condition', style: TextStyle(
                                  fontSize: 28, color: Colors.white
                                ),)
                              ],
                            )
                          ],
                        )
                      ],
                    ),


                  )
                ],
              ),
            ),
          ),

          Padding(

            padding:  EdgeInsets.only(top: 35 * SizeConfig.heightMultiplier),
            child: Container(

              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                Padding(
                padding:  EdgeInsets.only( top: 3 * SizeConfig.heightMultiplier),
                child: Text("$cityName, $country", style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 4.2 * SizeConfig.textMultiplier
                ),),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.location_on, color: Colors.orange,),
                        Text('$lat, $lon')
                      ],
                    ),
                    SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              print('Card tapped.');
                            },
                            child: Container(
                              width: 110,
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Feels Like :', style: TextStyle(
                                    fontSize: 16,

                                  ),),

                                  Text('$feelsLike °C', style: TextStyle(
                                    fontSize: 28,
                                      color: Colors.blueAccent
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              print('Card tapped.');
                            },
                            child: Container(
                              width: 110,
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Visibility :', style: TextStyle(
                                    fontSize: 16,

                                  ),),

                                  Text('$visibility', style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.blueGrey
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              print('Card tapped.');
                            },
                            child: Container(
                              width: 110,
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Pressure :', style: TextStyle(
                                    fontSize: 16,

                                  ),),

                                  Text('$pressure', style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.blueGrey
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              print('Card tapped.');
                            },
                            child: Container(
                              width: 110,
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Humidity :', style: TextStyle(
                                    fontSize: 16,

                                  ),),

                                  Text('$humidity', style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.blueGrey
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              print('Card tapped.');
                            },
                            child: Container(
                              width: 110,
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Min Temp :', style: TextStyle(
                                    fontSize: 16,

                                  ),),

                                  Text('$mintemp °C', style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.blueAccent
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              print('Card tapped.');
                            },
                            child: Container(
                              width: 110,
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Max Temp :', style: TextStyle(
                                    fontSize: 16,

                                  ),),

                                  Text('$maxtemp °C', style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.blueAccent
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                   Container(
                      height: 28 * SizeConfig.heightMultiplier,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 18,
                          ),
                          Text('Sunrise and sunset :', style: TextStyle(
                            fontSize: 20
                          ),),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Card(
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    print('Card tapped.');
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 110,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Image.asset('assets/014-haze.png', width: 60,),

                                        Text('$sunrise', style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueAccent
                                        ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    print('Card tapped.');
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 110,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Image.asset('assets/009-sunset.png', width: 60,),

                                        Text('$sunset', style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueAccent
                                        ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

              ),

            ),
          )

        ],
      ),

    );
  }



}
