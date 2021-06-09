import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/views/addpostView.dart';
import 'package:copenhagen_nature_explorer/views/directionsView.dart';
import 'package:flutter/material.dart';
import 'package:copenhagen_nature_explorer/views/homeView.dart';
import 'package:copenhagen_nature_explorer/views/loginView.dart';
import 'package:copenhagen_nature_explorer/views/registerView.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Setting up my services -> For the service locator.
  setupServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Find your adventure",
      theme: ThemeData(
          primarySwatch: Colors.green, accentColor: Colors.lightGreenAccent),
      home: HomeView(),
      routes: {
        HomeView.route: (context) => HomeView(),
        LoginView.route: (context) => LoginView(),   
        RegisterView.route: (context) => RegisterView(),
        AddPostView.route: (context) => AddPostView(),
        DirectionsView.route: (context) => DirectionsView(),
      },
      initialRoute: LoginView.route,
    );
  }
}
