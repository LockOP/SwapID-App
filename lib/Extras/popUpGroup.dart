import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1/Extras/helperFunctions.dart';
import 'package:project_1/firebase/auth.dart';
import 'package:project_1/firebase/database.dart';
import 'package:project_1/screens/groupSettings.dart';

enum Menu{NewGroup, Settings}

class PopupGroupScreen extends StatefulWidget {

  final String userId;
  PopupGroupScreen({this.userId, Key key}) : super(key : key);

  @override
  _PopupGroupScreenState createState() => _PopupGroupScreenState();
}

class _PopupGroupScreenState extends State<PopupGroupScreen> {


  String username, userEmail, groupName;

  TextEditingController groupNameController = TextEditingController();

  AuthService authService = AuthService();
  Database database = Database();

  remove() async{
    HelperFunctions.saveUserEmailSharedPreference(null);
  }

  getUserInfo() async{
    userEmail = await HelperFunctions.getUserEmailSharedPreference();
  }

  newGroup() async {
    String groupId = "${DateTime
        .now()
        .millisecondsSinceEpoch}";
    List<String> users = [widget.userId];
    List<String> reportedUsers = [];

    DocumentSnapshot userInfoSnapshot = await Database().getUserInfo(widget.userId);
    var userName = userInfoSnapshot.data()["name"];
    var userToken = userInfoSnapshot.data()["userToken"];

    Map<String, dynamic> groupNameMap = {
      "Group_Name": groupName,
      "Time": DateTime.now(),
      "postScreenId": groupId,
      "groupCreator": widget.userId,
      "users": users,
      "lastSender": "",
      "reportedUsers": reportedUsers,
    };

    Map<String, dynamic> groupMemberMap = {
      "userEmail": widget.userId,
      "userName": userName,
      "userToken" : userToken,
      "time": DateTime
          .now()
          .millisecondsSinceEpoch,
    };

    await database.addGroupName(
        groupId: groupId + widget.userId, groupNameMap: groupNameMap);
    await database.addMembersInGroup(
      groupMemberMap: groupMemberMap,
      phone: widget.userId,
      id: groupId + widget.userId,
    );
  }

  setGroupName(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 240,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent[700],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("Group Name",style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),)),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      controller: groupNameController,
                      maxLength: 30,
                      decoration: InputDecoration(
                        hintText: "Enter Group Name",
                      ),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          child: Text("Cancel", style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          child: Text("Create", style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                          ),
                          onPressed: () {
                            groupName = groupNameController.text;
                            newGroup();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),

            ),
          );
        });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: Icon(Icons.more_vert, color: Colors.white, size: 28),
      itemBuilder: (BuildContext context){
        return <PopupMenuEntry<Menu>>[
          PopupMenuItem(
            child: GestureDetector(
              onTap: (){
                setGroupName(context);
              },
              child: Text("New Group", style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.black,
              ),),
            ),
            value: Menu.NewGroup,
          ),
          PopupMenuItem(
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => GroupSettings(userEmail: userEmail),
                ));
              },
              child: Text("Settings", style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.black,
              ),),
            ),
            value: Menu.Settings,
          ),
        ];
      },
    );
  }
}




