import 'package:flutter/material.dart';
import '../utils/routes.dart';
// Import the IntroSection widget
// import '../screens/latest_issuances.dart'; // Import your LatestIssuances page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      initialRoute: Routes.introsection, // Set the initial route
      routes: Routes.getRoutes(context),
    );
  }
}
