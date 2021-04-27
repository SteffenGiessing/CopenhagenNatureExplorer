import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/views/addpostView.dart';
import 'package:flutter/material.dart';
import './screens/feed.dart';
import './screens/add_place.dart';
import 'package:copenhagen_nature_explorer/views/homeView.dart';
import 'package:copenhagen_nature_explorer/views/loginView.dart';
import 'package:copenhagen_nature_explorer/views/profileView.dart';
import 'package:copenhagen_nature_explorer/views/registerView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:copenhagen_nature_explorer/views/addpostView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Find you adventure",
      theme: ThemeData(
          primarySwatch: Colors.green, accentColor: Colors.lightGreenAccent),
      home: PlacesListScreen(),
      routes: {
        AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
        HomeView.route: (context) => HomeView(),
        LoginView.route: (context) => LoginView(),
        ProfileView.route: (context) => ProfileView(),
        RegisterView.route: (context) => RegisterView(),
        AddPostView.route: (context) => AddPostView(),
      },
      initialRoute: LoginView.route,
    );
  }
}
