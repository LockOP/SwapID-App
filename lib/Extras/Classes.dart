import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1/Extras/helperFunctions.dart';
import 'package:project_1/Extras/popUpComment.dart';
import 'package:project_1/Extras/popUpPost.dart';
import 'package:project_1/firebase/database.dart';
import 'package:project_1/screens/CommentScreen.dart';
import 'package:project_1/screens/GroupProfileScreen.dart';
import 'package:project_1/screens/PostScreen.dart';

class Comments extends StatelessWidget {
  final String comment,
      time,
      day,
      memberPhone,
      memberName,
      postId,
      realUserIdForComment,
      commentId,
      groupCreatorId,
      userId,
      realUserId;

  Comments(
      {this.comment,
        this.time,
        this.day,
      this.memberPhone,
      this.commentId,
      this.realUserIdForComment,
      this.realUserId,
      this.userId,
      this.groupCreatorId,
      this.postId,
      this.memberName});

  MaterialColor _color =
      Colors.primaries[Random().nextInt(Colors.primaries.length)];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: CircleAvatar(
                  backgroundColor: _color,
                  radius: 20,
                  child: Text("${(memberName[0]).toUpperCase()}", style: TextStyle(
                    fontSize: 21,
                  ),),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.82,
                    decoration: BoxDecoration(
                      border: Border(
                        //bottom: BorderSide(color: Colors.grey[300]),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 32,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: memberName != null ? Text(
                                      memberName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    )
                                    :
                                    Text("")
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          memberPhone != null ? memberPhone : "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: time != null ? Text(
                                    time,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                  :
                                  Text("")
                                  ),
                                  Container(
                                    child: Text(
                                      day != null ? day : "",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              PopupCommentScreen(
                                groupCreatorId: groupCreatorId,
                                postId: postId,
                                commentId: commentId,
                                userId: userId,
                                realUserId: realUserId,
                                realUserIdForComment: realUserIdForComment,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 0, right: 18),
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 15, right: 0, left: 5),
                            child: Text(
                              comment,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class Post extends StatelessWidget {
  final int count;
  final String text,
      image,
      time,
      groupName,
      caption,
      commentTime,
      day,
      postId,
      memberName,
      commentSender,
      postScreenId,
      groupCreatorId,
      memberPhone,
      userId,
      realUserId;
  final Stream userStream;
  Post(
      { this.text,
        this.image,
        this.commentTime,
        this.time,
        this.day,
        this.caption,
        this.groupName,
        this.count,
        this.userStream,
        this.postId,
        this.commentSender,
        this.postScreenId,
        this.groupCreatorId,
        this.memberPhone,
        this.userId,
        this.realUserId,
        this.memberName});

  MaterialColor _color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        // Container(
        //   color: Colors.black,
        //   height: 1,
        // ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.0),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          backgroundColor: _color,
                          radius: 20,
                          child: Text("${(memberName[0]).toUpperCase()}", style: TextStyle(
                            fontSize: 21,
                          ),),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: memberName != null ? Text(
                                  memberName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[900],
                                    fontSize: 16,
                                  ),
                                )
                                    :
                                Text("")
                            ),
                            Container(
                              child: Text(
                                memberPhone != null ? memberPhone : "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              child: time != null ? Text(
                                time,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                              )
                                  :
                              Text("")
                          ),
                          Container(
                            child: Text(
                              day != null ? day : "",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      PopupPostScreen(
                        groupCreatorId: groupCreatorId,
                        postId: postId,
                        userId: userId,
                        realUserId: realUserId,
                      ),
                    ],
                  ),
                  image == ""
                      ? Container(
                    width: MediaQuery.of(context).size.width,
                        child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                    ),
                  ),
                      )
                      : GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FullPostImage(image: image)
                      ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: image,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            //height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: image != null
                                ? Image.network(image, fit: BoxFit.contain)
                                : null,
                          ),
                        ),
                        caption != "" ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              child: Text(caption, style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              )),
                            ),
                          ),
                        )
                            :
                            Container(),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.grey[200]),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                    postId: postId,
                                    postScreenId: postScreenId,
                                    groupCreatorId: groupCreatorId,
                                    userId: userId,
                                    groupName: groupName,
                                    realUserId: realUserId,
                                    userStream: userStream,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.comment, color: Colors.grey[600], size: 20),
                                SizedBox(width: 5),
                                Container(
                                  child: Text(
                                    count == 0 ? "No Comments" : (count == 1 ? "$count  Comment" : "$count  Comments"),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              child: commentSender != null ?
                              Text("Last comment by " + commentSender + " at " + commentTime, style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),) : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}

class FullPostImage extends StatelessWidget {
  String image;
  FullPostImage({this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Hero(
        tag: image,
        child: Image.network(image),
      ),
    );
  }
}

class GroupTile extends StatefulWidget {
  final String postScreenId, groupName, creatorId, userId, lastSender, token;
  GroupTile(
      {this.groupName,
        this.lastSender,
        this.postScreenId,
        this.creatorId,
        this.token,
        this.userId});

  @override
  _GroupTileState createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {

  Stream userStream, postStream;
  Database database = Database();

  enterGroup() async {

    await database
        .getMembersFromGroup(id: widget.postScreenId + widget.creatorId)
        .then((val) {
      setState(() {
        userStream = val;
      });
    });

    await database
        .getPosts(groupCreatorId: widget.postScreenId + widget.creatorId)
        .then((val) {
      setState(() {
        postStream = val;
      });
    });

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostScreen(
              groupName: widget.groupName,
              postScreenId: widget.postScreenId,
              groupCreatorId: widget.postScreenId + widget.creatorId,
              userId: widget.userId,
              userStream: userStream,
              postStream: postStream,
            ),
          ),
        );

    await database.batchDelete(widget.postScreenId + widget.creatorId);
  }

  updateToken() async{
    if(widget.token != null){
      await database.updateFcmTokenInMembers(
        groupId: widget.postScreenId+widget.creatorId,
        email: widget.userId,
        token: widget.token,
      );
    }
    else{
      return;
    }
  }

  @override
  void initState() {
    updateToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            enterGroup();
          },
          child: Card(
            elevation: 13,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.group,
                        size: 30,
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 13),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.groupName,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(widget.lastSender != "" ?
                          "Last post by " + widget.lastSender : "No posts yet !",
                            style: TextStyle(
                            fontSize: 17,
                            color: Colors.indigoAccent[700],
                            fontWeight: FontWeight.w500,
                          ),),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 10, 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GroupProfile(
                                    userId: widget.userId,
                                    GroupName: widget.groupName,
                                    groupCreatorId: widget.postScreenId+widget.creatorId)));
                      },
                      child: Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical:3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[400], width: 1),
                          color: Colors.grey[100],
                        ),
                        child: Text(
                          "Group profile",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}

class UserTile extends StatefulWidget {
  String userName, userPhone;

  UserTile({this.userName, this.userPhone});

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {

  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: widget.userPhone,
          preferBelow: false,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              color: clicked ? Colors.indigoAccent : Colors.grey[300],
              borderRadius: BorderRadius.circular(30),
              //border: Border.all(color: clicked ? Colors.indigoAccent[700] : Colors.grey[700], width: 2),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                HelperFunctions.saveMemberPhoneSharedPreference(
                    widget.userPhone);
                HelperFunctions.saveMemberNameSharedPreference(
                    widget.userName);
                setState(() {
                  clicked = true;
                });
              },
              child: Container(
                child: Center(
                  child: Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: 16,
                      color: clicked ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

class UserPlate extends StatelessWidget {

  String email, name, groupCreatorId;
  UserPlate({this.email, this.name, this.groupCreatorId});

  Database database = Database();

  MaterialColor _color =
  Colors.primaries[Random().nextInt(Colors.primaries.length)];

  deleteUser() async {
    await database.removeUsersInGroupArray(
        id: groupCreatorId, phone: email);
    await database.removeUserFromMembers(
        groupCreatorId: groupCreatorId, removeUser: email);
  }

  removeUserFromGroup(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10.0)),
            child: Container(
              height: 220,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent[700],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("Remove User",style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),)),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      child: Text("Are you sure you want to remove this user from this group?", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),),
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
                          child: Text("Remove", style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                          ),
                          onPressed: () {
                            deleteUser();
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

  removeserFromGroup(BuildContext context) {
    Widget noButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget yesButton = FlatButton(
      child: Text(
        "Remove",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 16,
        ),
      ),
      onPressed: () {
        deleteUser();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Remove User",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      content: Text("Are you sure you want to remove this user from this group?"),
      actions: [
        noButton,
        yesButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onLongPress: (){
            removeUserFromGroup(context);
          },
          child: Container(
            height: 40,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          child: CircleAvatar(
                            backgroundColor: _color,
                            radius: 16,
                            child: Text("${(name[0]).toUpperCase()}", style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 0),
                            height: 40,
                            child: Center(
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name + " | ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        email,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
