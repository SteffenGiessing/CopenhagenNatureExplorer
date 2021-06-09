import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:copenhagen_nature_explorer/view_controller/user_controller.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/views/homeView.dart';

class RegisterView extends StatefulWidget {
  static String route = "register-view";
  
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: CircleAvatar(
                      backgroundColor: const Color(0x00000000),
                      radius: 50.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                              TextFormField(
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(hintText: "Username"),
                                  controller: displayNameController,
                                  ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(hintText: "Email"),
                                controller: emailController,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                decoration:
                                    InputDecoration(hintText: "Password"),
                                controller: passwordController,
                              ),
                              SizedBox(height: 10),
                              ElevatedButton.icon(
                                icon: Icon(
                                  Icons.add,
                                ),
                                label: Text(
                                  "Create Account",
                                ),
                                onPressed: () async {
                                  try {
                                    await locator
                                        .get<UserController>().registerEmailAndPassword
                                        (
                                          email: emailController.text,
                                          password: passwordController.text,
                                          displayName: displayNameController.text,
                                        );
                                    Navigator.pushNamed(context, HomeView.route);
                                  } catch (e) {
                                    print("Something went wrong");
                                  }
                                },
                              ),
                            ]))),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
