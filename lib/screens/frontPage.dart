import 'package:flutter/material.dart';
import 'package:project_1/screens/login.dart';
import 'package:project_1/screens/register.dart';

class FrontScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.35),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Register()
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigoAccent[700],
                  borderRadius: BorderRadius.circular(30),
                ),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(
                  child: Text("Create New Account",style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LogIn(),
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigoAccent[700],
                  borderRadius: BorderRadius.circular(30),
                ),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(
                  child: Text("Login",style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
