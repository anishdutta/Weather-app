
import 'package:flutter/material.dart';
import 'package:flutter_traveler_profile_app/SizeConfig.dart';
import 'package:flutter_traveler_profile_app/profilefirst.dart';
import 'loading_screen.dart';

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
              home: LoadingScreen(),
            );
          },
        );
      },
    );
  }
}

