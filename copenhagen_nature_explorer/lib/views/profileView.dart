import 'dart:io';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/userModel.dart';
import 'package:copenhagen_nature_explorer/view_controller/user_controller.dart';
import 'package:copenhagen_nature_explorer/views/ProfileHandler.dart/ProfileHandler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:copenhagen_nature_explorer/views/avatarHandler.dart/avatar.dart';

class ProfileView extends StatefulWidget {
  static String route = "profile-view";

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserModel _currentUser = locator.get<UserController>().currentUser;
  // var emailController = TextEditingController(text: );
  final picker = ImagePicker();
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Avatar(
                    avatarUrl: _currentUser?.avatarUrl,
                    onTap: () async {
                      final image =
                          await picker.getImage(source: ImageSource.camera);
                      if (image == null) {
                        return;
                      } else {
                        await locator
                            .get<UserController>()
                            .uploadProfilePicture(File(image.path));
                        setState(() {});
                      }
                    },
                  ),
                  //Text("${_currentUser.displayName}"),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ProfileHandler(
              currentUser: _currentUser,
            ),
          ),
        ],
      ),
    );
  }
}
