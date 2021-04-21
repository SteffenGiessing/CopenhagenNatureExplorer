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
                    SizedBox(height: 10,),
                    ImageInput()
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
            onPressed: () {
              print("works");
            },
          ),
        ],
      ),
    );
  }
}
