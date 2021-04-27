// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as systemPath;

// /*
// */
// class ImageInput extends StatefulWidget {
//   final Function selectedImage;
//   ImageInput(this.selectedImage);

//   @override
//   _ImageInputState createState() => _ImageInputState();
// }

// class _ImageInputState extends State<ImageInput> {
//   File _image;
//   final picker = ImagePicker();

//   Future<void> _takePicture() async {
//     final imageFile = await picker.getImage(source: ImageSource.camera);
//     if (imageFile == null) {
//       return;
//     }
//     setState(() {
//       _image = File(imageFile.path);
//     });
//     final appDir = await systemPath.getApplicationDocumentsDirectory();
//     final fileName = path.basename(imageFile.path);
//     final savedImage =
//         await File(imageFile.path).copy('${appDir.path}/$fileName');
//     widget.selectedImage(savedImage);
//   }

//   //Image
//   @override
//   Widget build(BuildContext context) {
//     return Row(children: <Widget>[
//       Container(
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//             border: Border.all(width: 1, color: Colors.greenAccent)),
//         child: _image != null
//             ? Image.file(_image, fit: BoxFit.cover, width: double.infinity)
//             : Text("No picture", textAlign: TextAlign.center),
//         alignment: Alignment.center,
//       ),
//       SizedBox(
//         width: 10,
//       ),
//       Expanded(
//         child: TextButton.icon(
//           icon: Icon(Icons.camera),
//           style: TextButton.styleFrom(
//             primary: Colors.lightGreenAccent,
//           ),
//           label: Text("Take Picture"),
//           onPressed: _takePicture,
//         ),
//       ),
//     ]);
//   }
// }
