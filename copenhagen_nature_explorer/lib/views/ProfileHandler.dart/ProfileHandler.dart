import 'package:copenhagen_nature_explorer/models/userModel.dart';
import 'package:copenhagen_nature_explorer/view_controller/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:copenhagen_nature_explorer/locator.dart';

class ProfileHandler extends StatefulWidget {
  final UserModel currentUser;
  ProfileHandler({this.currentUser});

  // UserController _userController = UserController();
  // var getUserInfo = _userController.getUserInfo();
  @override
  _ProfileHandlerState createState() => _ProfileHandlerState();
}

class _ProfileHandlerState extends State<ProfileHandler> {
  var _formKey = GlobalKey<FormState>();
  var _displayNameController = TextEditingController();
  var _passwordController = TextEditingController();
  //  var _newPasswordController = TextEditingController();
  //  var _repeatPasswordController = TextEditingController();

  @override
  void initState() {
    _displayNameController.text = widget.currentUser.displayName;
    _passwordController.text = widget.currentUser.uid;
    print("${_displayNameController.text} empty: ${_passwordController.text}");
    super.initState();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    //  _passwordController.dispose();
    //  _newPasswordController.dispose();
    //  _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: "Steffen"),
              controller: _displayNameController,
            ),
            SizedBox(height: 20.0),
            Flexible(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: "Email"),
                      controller: _passwordController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "AnotherField"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "YetAnotherField"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () async {
                var userController = locator.get<UserController>();
                Navigator.pop(context);
                setState(() {});
              },
              child: Text("Save Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
