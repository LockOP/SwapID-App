import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:project_1/Extras/helperFunctions.dart';
import 'package:project_1/firebase/auth.dart';
import 'package:project_1/firebase/database.dart';
import 'package:project_1/screens/intro.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final formKey = GlobalKey<FormState>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool isLoading = false;

  AuthService authService = AuthService();
  Database database = Database();

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  userAlreadyExistError(BuildContext context) {
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
      content: Text("This email is already registered. Try another email.",
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

  signMeUp() async{

    var token = await _firebaseMessaging.getToken();

    await database.alreadyExistingEmail(emailTextEditingController.text.trim()).then((val){
      if(val == true){
        userAlreadyExistError(context);
      }else{
        if(formKey.currentState.validate()){

          Map<String, String> userInfoMap = {
            "name" : userNameTextEditingController.text.trim(),
            "email" : emailTextEditingController.text.trim(),
            "store" : passwordTextEditingController.text.trim(),
            "userToken" : token,
          };

          Map<String, String> userEmailMap = {
            "email" : ""
          };

          HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text.trim());
          HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text.trim());

          HelperFunctions.saveMemberPhoneSharedPreference(
             emailTextEditingController.text.trim());
          HelperFunctions.saveMemberNameSharedPreference(
              userNameTextEditingController.text.trim());
          setState(() {
            isLoading = true;
          });

          authService.signUpWithEmailAndPassword(emailTextEditingController.text.trim(),
              passwordTextEditingController.text.trim()).then((val) async{

             await database.createUserList(email: emailTextEditingController.text.trim(), userEmail: userEmailMap);
           await database.addUserInfo(userData: userInfoMap, userId: emailTextEditingController.text.trim());
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => IntroductionPage(phoneController: emailTextEditingController.text.trim(), intro: true)
            ));
          });

        }
      }
    });

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
                  Container(height: MediaQuery.of(context).size.height * 0.3),
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
                        controller: userNameTextEditingController,
                        keyboardType: TextInputType.text,
                        validator: (val){
                          return val.length < 3 || val.length > 10  ? " Username should be of 3 to 10 characters" : null;
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
                            hintText: "Username"
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
                          return val.length < 6 ? "Password should be greater than 6 characters" : null;
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
                      signMeUp();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent[700],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Center(
                        child: Text("SignIn",style: TextStyle(
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
          ),
        ),
      ),
    );
  }
}
