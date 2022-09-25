import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_1/Extras/Classes.dart';
import 'package:project_1/Extras/helperFunctions.dart';
import 'package:project_1/firebase/database.dart';

class CommentScreen extends StatefulWidget {

  final String postId, postScreenId, userId, groupName, groupCreatorId, realUserId;
  final Stream userStream;
  CommentScreen({this.postId, this.userStream, this.groupName, this.postScreenId, this.userId, this.groupCreatorId, this.realUserId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  final String commentScreenId = "${DateTime.now().millisecondsSinceEpoch}";
  TextEditingController commentController = TextEditingController();
  Database database = Database();
  Stream commentStream;
  int count;

  final formKey = GlobalKey<FormState>();


  Widget commentList(){
    return StreamBuilder(
      stream: commentStream,
      builder: (context, snapshot){
        return snapshot.hasData ? Stack(
          children: [
            ListView.builder(
              itemCount: count = snapshot.data.documents.length,
              itemBuilder: (context, index){
                return Comments(
                    comment: snapshot.data.documents[index].data()["comment"],
                    memberPhone: snapshot.data.documents[index].data()["sendByName"],
                    userId: widget.userId,
                    commentId: snapshot.data.documents[index].data()["commentId"],
                    postId: widget.postId,
                    time: snapshot.data.documents[index].data()["time"],
                    day: snapshot.data.documents[index].data()["day"],
                    groupCreatorId: widget.groupCreatorId,
                    memberName: snapshot.data.documents[index].data()["nameSent"],
                    realUserIdForComment: snapshot.data.documents[index].data()["realUser"],
                    realUserId: widget.realUserId,
                );
              },
            ),

          ],
        )
            :
            Container(color: Colors.grey[300]);
      },
    );
  }

  send() async{

    if(formKey.currentState.validate()) {

      String commentId = "${DateTime.now().millisecondsSinceEpoch}";
      dynamic time = DateFormat.jm().format(DateTime.now());
      var day = DateFormat('EEEE').format(DateTime.now());

      var displayEmail = await HelperFunctions.getMemberPhoneSharedPreference();
      var memberName = await HelperFunctions.getMemberNameSharedPreference();


      if(commentController != null){
        Map<String, dynamic> commentMap = {
          "time" : time,
          "day" : day,
          "comment" : commentController.text,
          "timeId" : DateTime.now().millisecondsSinceEpoch,
          "realUser" : widget.userId,
          "sendByName" : displayEmail,
          "nameSent" : memberName,
          "commentId" : commentId,
        };

        Map<String, dynamic> notificationMap = {
          "groupCreatorId": widget.groupCreatorId,
          "groupName": widget.groupName,
          "sender": memberName,
        };

        await database.addComment(
          commentMap: commentMap,
          commentSender: memberName,
          postId: widget.postId,
          groupCreatorId: widget.groupCreatorId,
          commentId: commentId,
          userId: widget.userId,
          realUserId: widget.realUserId,
        );

        await database.updateTotalComments(groupCreatorId: widget.groupCreatorId,
            commentSender: memberName, realUserId: widget.realUserId,
            postId: widget.postId, count: count);

        await database.addCommentNotification(notificationMap);

        commentController.text = "";
        commentId = "";
      }
    }

  }

  Widget _userList(){
    return StreamBuilder(
      stream: widget.userStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return UserTile(
                  userName: snapshot.data.documents[index].data()["userName"],
                  userPhone: snapshot.data.documents[index].data()["userEmail"],
              );
            })
            :
        Container();
      },
    );
  }

  @override
  void initState() {
    database.getComments(postId:widget.postId,
      groupCreatorId: widget.groupCreatorId, realUserId: widget.realUserId).then((val){
      setState(() {
        commentStream = val;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Comments", style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.white,
        ),),
        backgroundColor: Colors.indigoAccent[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: commentList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.chat,color: Colors.indigoAccent[700]),
        onPressed: () => commentBox(),
      ),
    );
  }


  Widget commentBox(){
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: "Label",
        transitionDuration: Duration(milliseconds: 50),
        context: context,
        pageBuilder: (context, a1, a2) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                child: Material(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        )
                    ),
                    height: 95,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 1),
                            height: 55,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 12,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 3),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(color: Colors.indigoAccent[700], width: 2),
                                        color: Colors.white,
                                      ),
                                      child: Form(
                                        key: formKey,
                                        child: Center(
                                          child: TextFormField(
                                            controller: commentController,
                                            validator: (val) {
                                              return val.isEmpty
                                                  ? "message field can't be empty"
                                                  : null;
                                            },
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            expands: true,
                                            cursorColor: Colors.grey[900],
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Type ...",
                                              isDense: true,
                                              hintStyle: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      send();
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      height: 55,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 7),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white,
                                          ),
                                          child: Icon(Icons.send, color: Colors.indigoAccent[700])
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 3, bottom: 5),
                            height: 40,
                            child: _userList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom)),
          );
        },
        transitionBuilder: (context, a1, a2, child) {
          return SlideTransition(
            position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                .animate(a1),
            child: child,
          );
        }
    );
  }

}

