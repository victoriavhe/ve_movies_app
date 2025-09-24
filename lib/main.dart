import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ve_movies_app/app/core/di/service_locator.dart';
import 'package:ve_movies_app/app/presentation/views/home/home_view.dart';

void main() async {
  setupDependencies();
  await dotenv.load(fileName: "assets/env/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streaming App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

