import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}


class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String error = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _checkLoginState(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.hasError}");
            } else {
              var user = snapshot.data as User;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  snapshot.hasData
                      ? Text("LoggedIn User is : ${user.phoneNumber}")
                      : Text("Tap the below button to login"),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: RaisedButton(
                      child: Text(snapshot.hasData ? "Logout" : "Login"),
                      onPressed: _pressedLogin,
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<User> _checkLoginState() async {
    await Firebase.initializeApp();
    return FirebaseAuth.instance.currentUser;
  }

  void _pressedLogin() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FirebaseAuthUi.instance()
          .launchAuth([AuthProvider.phone()]).then((value) {
        setState(() {
          error = "";
        });
      }).catchError((e) {
        if (e is PlatformException) {
          setState(() {
            if (e.code == FirebaseAuthUi.kFirebaseError) {
              error = "User Cancelled Login";
            } else {
              error = e.message ?? "Link Error";
            }
          });
        }
      });
    } else {
      //if user already loggedin.logged out
      FirebaseAuthUi.instance().logout();
      setState(() {});
    }
  }
}
