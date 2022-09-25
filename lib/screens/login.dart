import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:project_1/Extras/helperFunctions.dart';
import 'package:project_1/firebase/auth.dart';
import 'package:project_1/firebase/database.dart';
import 'package:project_1/screens/GroupScreen.dart';
import 'package:project_1/screens/register.dart';

class LogIn extends StatefulWidget {

  String cacheEmail;
  LogIn({this.cacheEmail});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  AuthService authService =  AuthService();
  Database database = Database();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isLoading = false;
  DocumentSnapshot snapshotUserInfo;

  logInError(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK", style: TextStyle(
        color: Colors.blue,
        fontSize: 20,
      ),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Error", style: TextStyle(
        fontSize: 22,
      ),),
      content: Text("It seems either email or password is incorrect.",
        style: TextStyle(
          fontSize: 18,
        ),),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  signIn() async{

    if(formKey.currentState.validate()){

      var token = widget.cacheEmail == null ? await _firebaseMessaging.getToken() : null;

      authService.signInWithEmailAndPassword(emailTextEditingController.text.trim(),
          passwordTextEditingController.text.trim()).then((val){
        if(val != null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => GroupScreen(token: token, userId: emailTextEditingController.text.trim())
          ));
        }else{
          logInError(context);
        }
      });

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text.trim());
      HelperFunctions.saveMemberPhoneSharedPreference(
          emailTextEditingController.text.trim());

      setState(() {
        isLoading = true;
      });

      if(widget.cacheEmail == null){
        await database.updateFcmToken(email: emailTextEditingController.text.trim(),
            token: token);
      }

      await database.getUserInfo(emailTextEditingController.text)
          .then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.data()["name"]);
        HelperFunctions.saveMemberNameSharedPreference(snapshotUserInfo.data()["name"]);
      });

    }
  }
  

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      color: Colors.white,
      height: 40,
      width: 40,
      child: Center(
        child: CircularProgressIndicator(
          valueColor:AlwaysStoppedAnimation<Color>(Colors.indigoAccent[700]),
        ),
      ),
    ) : Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(height: MediaQuery.of(context).size.height * 0.27),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.indigoAccent, width: 2),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                      child: TextFormField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val){
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val) ? null : 'Provide a valid EmailId' ;
                        },
                        style: TextStyle(
                          fontSize: 17,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.indigoAccent[200],
                              fontWeight: FontWeight.w400,
                            ),
                            hintText: "Email"
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.indigoAccent, width: 2),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                      child: TextFormField(
                        controller: passwordTextEditingController,
                        validator:  (val){
                          return val.length < 6 ? " Password should be greater than 6 characters" : null;
                        },
                        obscureText: true,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.indigoAccent[200],
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: "Password",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      signIn();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent[700],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Center(
                        child: Text("LogIn",style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Register()
                      ));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      child: Center(
                        child: Column(
                          children: [
                            Text("Don't have an Account?",style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),),
                            Text(" SignUp!",style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.bold,
                            ),),
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
      ),
    );
  }
}
