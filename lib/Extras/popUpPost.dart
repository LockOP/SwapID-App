import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1/firebase/database.dart';

enum Menu{Delete, Report}

class PopupPostScreen extends StatefulWidget {

  String groupCreatorId, postId, userId, realUserId, imagePost, textPost;
  PopupPostScreen({Key key, this.groupCreatorId, this.imagePost, this.textPost, this.userId, this.realUserId, this.postId}) : super(key : key);

  @override
  _PopupPostScreenState createState() => _PopupPostScreenState();
}

class _PopupPostScreenState extends State<PopupPostScreen> {

  Database database = Database();
  bool userAlreadyReported = false;
  int totalMember, totalReporter;
  var removeRealUser;

  reportUser() {
    if(userAlreadyReported){
      return alreadyReported(context);
    }else{
      return report(context);
    }
  }

  check() async{
    await database.checkIfUserHasAlreadyReportedPost(
        groupCreatorId: widget.groupCreatorId,
        postId: widget.postId,
        userId: widget.userId,
    ).then((val){
      userAlreadyReported = val;
    });
    reportUser();
  }

  alreadyReported(BuildContext context) {

    Widget okButton = FlatButton(
      child: Text("OK",style: TextStyle(
        color: Colors.blue,
        fontSize: 20,
      ),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text("You have already reported this post.", style: TextStyle(
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

  addReporter() async{
    Map<String, dynamic> reporterMap = {
      "reporter": widget.userId,
    };

    await database.addNewReporterPost(
      reporterMap: reporterMap,
      postId: widget.postId,
      groupCreatorId: widget.groupCreatorId,
      userId: widget.userId,
    );

    await removeUser();
  }

  removeUser() async{

     await database.memberDocLength(widget.groupCreatorId).then((val){
      totalMember = val;
      print(totalMember);
    });

     await database.reporterDocLength(groupCreatorId: widget.groupCreatorId, postId: widget.postId)
    .then((val){
      totalReporter = val;
      print(totalReporter);
    });

     Map<String,dynamic> reportedUserMap = {
       "reported" : widget.realUserId,
     };

    if((totalMember - totalReporter) == 1){
      await database.removeUserFromMembers(groupCreatorId: widget.groupCreatorId, removeUser: widget.realUserId);
      await database.removeUsersInGroupArray(id: widget.groupCreatorId, phone: widget.realUserId);
      await database.addInReportedCollection(groupCreatorId: widget.groupCreatorId,
          reportedUserPhoneMap: reportedUserMap, removeUserId: widget.realUserId);
      await database.deletePost(groupCreatorId: widget.groupCreatorId,
          postId: widget.postId, userId: widget.realUserId);
    }
  }

  delete() async{
    await database.deletePost(groupCreatorId: widget.groupCreatorId,
        postId: widget.postId, userId: widget.userId);
  }

  deleteOptions(BuildContext context) {

    Widget cancelButton = FlatButton(
      child: Text("Cancel",style: TextStyle(
        color: Colors.blue,
        fontSize: 16,
      ),),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete",style: TextStyle(
        fontSize: 20,
      ),),
      content: Container(
        height: 100,
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: (){
                  delete();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text("Delete for everyone", style: TextStyle(
                  fontSize: 17,
                  color: Colors.blue,
                ),),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text("(*It will be deleted for everyone only if it was sent by you)",
                style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),),
            ),

          ],
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  report(BuildContext context) {

    Widget noButton = FlatButton(
      child: Text("No",style: TextStyle(
        color: Colors.blue,
        fontSize: 16,
      ),),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    Widget yesButton = FlatButton(
      child: Text("Yes",style: TextStyle(
        color: Colors.blue,
        fontSize: 16,
      ),),
      onPressed: () {
        addReporter();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Report",
        style: TextStyle(
        fontSize: 20,
      ),),
      content: Text("Are you sure you want report this user ?",
        style: TextStyle(
        fontSize: 17,
      ),),
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
    return PopupMenuButton<Menu>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600], size: 25),
      itemBuilder: (BuildContext context){
        return <PopupMenuEntry<Menu>>[
          PopupMenuItem(
            child: GestureDetector(
              onTap: () {
                deleteOptions(context);
              },
              child: Text("Delete", style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),),
            ),
            value: Menu.Delete,
          ),
          PopupMenuItem(
            child: GestureDetector(
              onTap: (){
                check();
              },
              child: Text("Report",
                style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),),
            ),
            value: Menu.Report,
          ),
        ];
      },
    );
  }
}