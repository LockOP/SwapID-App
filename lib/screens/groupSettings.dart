import 'package:flutter/material.dart';
import 'package:project_1/Extras/helperFunctions.dart';
import 'package:project_1/firebase/auth.dart';
import 'package:project_1/screens/intro.dart';
import 'package:project_1/screens/login.dart';

class GroupSettings extends StatefulWidget {

  final String userEmail;
  GroupSettings({this.userEmail});

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {

  AuthService authService = AuthService();

  remove() async{
    HelperFunctions.saveUserEmailSharedPreference(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent[700],
        title: Text("", style: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  child: Icon(Icons.account_circle, color: Colors.grey[700], size: 31),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey[200]),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 24, 0, 15),
                            child: Text("Account Info", style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),),
                          ),
                          SizedBox(height: 10),
                          Text("      Email Id", style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),),
                          Text(widget.userEmail != null ? "      " + widget.userEmail : "", style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => IntroductionPage(intro: false)
                ));
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(Icons.apps, color: Colors.grey[700], size: 30),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.grey[200]),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text("About App", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),),
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                remove();
                authService.signOut();
                HelperFunctions.saveUserLoggedInSharedPreference(false);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    LogIn()), (Route<dynamic> route) => false);
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(Icons.exit_to_app, color: Colors.grey[700], size: 30),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text("Logout", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
