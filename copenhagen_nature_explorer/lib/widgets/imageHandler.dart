import 'package:flutter/material.dart';
import 'dart:io';
class ImageInput extends StatefulWidget {

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {

  File _storedImage;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
        width: 100, 
        height: 100, 
        decoration: BoxDecoration(
          border: Border.all(width:1, color:Colors.greenAccent)
        ),
        child:  _storedImage != null ? 
        Image.file(
          _storedImage, 
          fit: BoxFit.cover, 
          width: double.infinity
          )
        : Text("No picture", textAlign: TextAlign.center),
      alignment: Alignment.center,
      ),
      SizedBox(width: 10,),
      Expanded(
        child: TextButton.icon(
          icon: Icon(Icons.camera),
          style: TextButton.styleFrom(
            primary: Colors.lightGreenAccent,
          ),
          label: Text("Take Picture"),
          onPressed: () {},
        ),
      ),
    ]
    );
  }
}
