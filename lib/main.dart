import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_1/Extras/helperFunctions.dart';
import 'package:project_1/screens/GroupScreen.dart';
import 'package:project_1/screens/frontPage.dart';
import 'package:project_1/screens/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String email = await HelperFunctions.getUserEmailSharedPreference();
  bool loggedIn = await HelperFunctions.getUserLoggedInSharedPreference();
  loggedIn = loggedIn != null ? loggedIn : false;
  runApp(MyApp(email: email, loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {

  String email;
  bool loggedIn;
  MyApp({this.email, this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SwapId',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: email != null ?
      (loggedIn ? GroupScreen(userId: email) : LogIn(cacheEmail: email))
      :
      FrontScreen(),
    );
  }
}



