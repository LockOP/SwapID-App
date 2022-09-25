import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_1/Extras/Classes.dart';
import 'package:project_1/firebase/database.dart';

class GroupProfile extends StatefulWidget {
  String groupCreatorId, userId, GroupName;
  GroupProfile({this.groupCreatorId, this.userId, this.GroupName});

  @override
  _GroupProfileState createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
  Database database = Database();
  String user;
  bool check = false;
  String group_Name;
  File _image;
  String displayImage;
  bool imageUrl = false;
  ImagePicker _picker = ImagePicker();
  var memberLength;

  TextEditingController phoneInputController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  Stream userStream;

  showAlreadyReportedUser(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Error",
        style: TextStyle(
          fontSize: 22,
        ),
      ),
      content: Text(
        "This user has been reported and removed from this group .",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
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

  show(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)),
            child: Container(
              height: 200,
              //width: 200,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("Error !",style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),)),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      child: Text("This user has been reported and removed from this group .", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),),
                    ),
                  ),
                ],
              ),

            ),
          );
        });
  }

  addMember() async {

    if(memberLength < 10){

      DocumentSnapshot userInfoSnapshot =
      await database.getUserInfo(phoneInputController.text.trim());
      var userName = userInfoSnapshot.data()["name"];
      var userToken = userInfoSnapshot.data()["userToken"];


      Map<String, dynamic> groupMemberMap = {
        "userEmail": phoneInputController.text.trim(),
        "time": DateTime.now().millisecondsSinceEpoch,
        "userName": userName,
        "userToken": userToken,
      };

      await database
          .checkIfReportedUserTriedToAddAgain(
          groupCreatorId: widget.groupCreatorId,
          reportedUserId: phoneInputController.text.trim())
          .then((val) {
        check = val;
      });

      if (check) {
        show(context);
      } else {
        await database.addUsersInGroupArray(
            id: widget.groupCreatorId, phone: phoneInputController.text.trim());
        await database.addMembersInGroup(
          groupMemberMap: groupMemberMap,
          phone: phoneInputController.text.trim(),
          id: widget.groupCreatorId,
        );
      }

      phoneInputController.text = "";
    }
    else{
      return memberLengthExceeded(context);
    }

  }

  memberLengthExceeded(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              //width: 200,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("Error !",style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),)),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      child: Text("The group already has 10 members", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),),
                    ),
                  ),
                ],
              ),

            ),
          );
        });
  }

  noUser(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              //width: 200,
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
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("Error !",style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),)),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      child: Text("It seems this Email id is not registered.", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),),
                    ),
                  ),
                ],
              ),

            ),
          );
        });
  }

  updateGroup() async {
    await database.updateGroupName(
        groupId: widget.groupCreatorId, val: groupNameController.text.trim());
  }

  getNameOfGroup() async {
    QuerySnapshot snapshot = await database.getGroupName(widget.groupCreatorId);
    group_Name = snapshot.docs[0].get("Group_Name");
    GroupTile(groupName: group_Name);
  }

  updateGroupName(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 250,
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
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("Change Group Name",style: TextStyle(
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
                          child: Text("Update", style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                          ),
                          onPressed: () {
                            updateGroup();
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

  deleteGroup() async {
    await database.removeUsersInGroupArray(
        id: widget.groupCreatorId, phone: widget.userId);
    await database.removeUserFromMembers(
        groupCreatorId: widget.groupCreatorId, removeUser: widget.userId);
  }

  exitGroup(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 230,
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
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("Exit & Delete Group",style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),)),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      child: Text("Are you sure you want to exit this group?", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                        child: Text("No", style: TextStyle(
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
                          child: Text("Yes", style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                          ),
                          onPressed: () {
                            deleteGroup();
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

  Widget _userList() {
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Scrollbar(
                child: ListView.builder(
                    itemCount: memberLength = snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return UserPlate(
                        email: snapshot.data.documents[index].data()["userEmail"],
                        name: snapshot.data.documents[index].data()["userName"],
                        groupCreatorId: widget.groupCreatorId,
                      );
                    }),
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    database.getMembersFromGroup(id: widget.groupCreatorId).then((val) {
      setState(() {
        userStream = val;
      });
    });

    getNameOfGroup();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent[700],
          title: Text(widget.GroupName != null ? widget.GroupName : "New Group", style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, size: 25, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: (){
                updateGroupName(context);
              },
              icon: Icon(Icons.create, size: 25, color: Colors.white),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 90,
                color: Colors.grey[200],
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add,
                      size: 35,
                      color: Colors.indigoAccent[700],
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          controller: phoneInputController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "AddMember(Enter email)",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        database
                            .checkIfUserExists(phoneInputController.text.trim())
                            .then((val) {
                          return val ? addMember() : noUser(context);
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[600],
                padding: EdgeInsets.all(5),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: _userList(),
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: (){
                  exitGroup(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[600], width: 5),
                  ),
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: Center(
                    child: Text("Exit & Delete Group", style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }


}
