import 'dart:io';
import 'package:provider/provider.dart';
import '../provider/user_places.dart';
import 'package:copenhagen_nature_explorer/screens/place_details.dart';
import 'package:flutter/material.dart';
import '../widgets/imageHandler.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = "/add-place";

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();

  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      //TODO: Add Snackbar or toast message
      return;
    }
    Provider.of<CreatedPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Place"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: "Title"),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Image(_selectImage),
                  ],
                ),
              ),
            ),
          ),
          Text("User Inputs"),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightGreen,
            ),
            label: Text("okay"),
            icon: Icon(Icons.add),
            onPressed: _savePlace,
          ),
        ],
      ),
    );
  }
}
