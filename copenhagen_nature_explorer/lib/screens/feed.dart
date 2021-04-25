import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './add_place.dart';
import 'package:provider/provider.dart';
import '../provider/user_places.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Places'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
            ),
          ],
        ),
        body: Consumer<CreatedPlaces>(
          child: Center(
            child: Text("Got no places"),
          ),
          builder: (context4, createdPlaces, ch) => createdPlaces.items.length <= 0
              ? ch
              : ListView.builder(
                  itemCount: createdPlaces.items.length,
                  itemBuilder: (ctx, i) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            FileImage(createdPlaces.items[i].image),
                      ),
                      title: Text(createdPlaces.items[i].description),
                      onTap: () {
                        //Later
                      }
                    ),
                ),
        ),
      );
  }
}
