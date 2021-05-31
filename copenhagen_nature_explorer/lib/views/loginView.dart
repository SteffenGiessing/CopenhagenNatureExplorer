import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/view_controller/user_controller.dart';
import 'package:copenhagen_nature_explorer/views/homeView.dart';
import 'package:copenhagen_nature_explorer/views/registerView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginView extends StatefulWidget {
  static String route = "login";

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var emailController = TextEditingController(text: "newUser@newUser.com");
  var passwordController = TextEditingController(text: "1234567");

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
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
          // decoration: BoxDecoration(
          //color: Colors.green, backgroundBlendMode: BlendMode.darken),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20.0),
                Center(
                  child: CircleAvatar(
                    backgroundColor: const Color(0x00000000),
                    //backgroundImage: AssetImage("assets/images/logo.png"),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(hintText: "Email"),
                            controller: emailController,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(hintText: "Password"),
                            controller: passwordController,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            //color: Theme.of(context).primaryColor,
                            icon: Icon(
                              Icons.verified_user,
                              color: textTheme.button.color,
                            ),
                            label: Text(
                              "Sign in",
                              style: textTheme.button,
                            ),
                            onPressed: () async {
                              try {
                                await locator
                                    .get<UserController>()
                                    .signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);
                                Navigator.pushNamed(context, HomeView.route);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Either Email or Password is wrong please try again"),
                                  ),
                                );
                              }
                            },
                          ),
                          ElevatedButton.icon(
                              icon: Icon(
                                Icons.add_circle_outline_outlined,
                                color: textTheme.button.color,
                              ),
                              label: Text(
                                "Register",
                                style: textTheme.button,
                              ),
                              onPressed: () async {
                                Navigator.pushNamed(
                                    context, RegisterView.route);
                              }),
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
