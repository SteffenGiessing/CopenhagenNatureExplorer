import 'package:copenhagen_nature_explorer/view_controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:copenhagen_nature_explorer/views/homeView.dart';
import 'package:image_picker/image_picker.dart';

class AddPostView extends StatefulWidget {
  static String route = "addpost";

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPostView> {
  var _infoText = TextEditingController();
  final picker = ImagePicker();
  File _image;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://source.unsplash.com/1600x900/?nature"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20.0),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                    },
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Color(0xBBFFFFFF),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _image != null
                          ? Image.file(
                              _image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Text(
                              "Share you picture",
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xBBFFFFFF),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText:
                                    "Any advise for reaching this place?"),
                            controller: _infoText,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            //color: Theme.of(context).primaryColor,
                            icon: Icon(
                              Icons.local_post_office_outlined,
                              color: textTheme.button.color,
                            ),
                            label: Text(
                              "Add Post",
                              style: textTheme.button,
                            ),
                            onPressed: () async {
                              try {
                                await locator.get<PostController>().createPost(
                                    infoText: _infoText.text, image: _image);

                                Navigator.pushNamed(context, HomeView.route);
                              } catch (e) {
                                SnackBar(
                                  content: Text(
                                      "Incorrect values please try again."),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
