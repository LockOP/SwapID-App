import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_1/Extras/Classes.dart';
import 'package:project_1/Extras/popUpGroup.dart';
import 'package:project_1/firebase/database.dart';


class GroupScreen extends StatefulWidget {
  final String userId, token;
  GroupScreen({this.userId, this.token});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  Database database = Database();

  String username, userEmail;
  String displayImage;
  bool imageUrl = false;
  Stream groupStream;

  Widget groupList() {
    return StreamBuilder(
      stream: groupStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return GroupTile(
                lastSender: snapshot.data.documents[index].data()["lastSender"],
                groupName: snapshot.data.documents[index].data()["Group_Name"],
                postScreenId: snapshot.data.documents[index]
                    .data()["postScreenId"],
                creatorId: snapshot.data.documents[index]
                    .data()["groupCreator"],
                userId: widget.userId,
                token: widget.token,
              );
            })
            : Container();
      },
    );
  }

  @override
  void initState() {
    userGroupInfo();

    super.initState();

  }

  userGroupInfo() async {

    await database.getGroupNameForUser(widget.userId).then((val) {
      setState(() {
        groupStream = val;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.indigoAccent[700],
          title: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "SwapId",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            PopupGroupScreen(userId: widget.userId),
          ]),
      body: Container(
        color: Colors.grey[200],
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: groupList(),
        ),
      ),
    );
  }

}

