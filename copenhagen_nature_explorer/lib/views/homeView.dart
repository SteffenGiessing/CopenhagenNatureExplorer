import 'package:copenhagen_nature_explorer/views/profileView.dart';
import 'package:copenhagen_nature_explorer/views/explorerView.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  static String route = "home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explorer"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.account_box_sharp),
              onPressed: () {
                Navigator.pushNamed(context, ProfileView.route);
              }),
        ],
      ),
      floatingActionButton: Container(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, ExplorerView.route);
            },
          ),
        ),
      ),
    );
  }
}
